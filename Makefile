path := .


.PHONY: is-archlinux
is-archlinux:
	@type pacman


.PHONY: clean
clean:
	@rm -rf yay


.PHONY: update
update: is-archlinux
	@pacman -Sy


.PHONY: locale
locale:
	@sed -i '/#en_US.UTF-8/s/^#//' /etc/locale.gen 
	@locale-gen


.PHONY: upgrade
upgrade: update
	@pacman -Su --noconfirm


.PHONY: operator
operator:
	@useradd -m -g wheel operator
	@echo "Which password do you want for operator user?"
	@passwd operator


.PHONY: neovim
neovim: is-archlinux
	@pacman --noconfirm --needed -S neovim
	@pacman --noconfirm -R vi
	@ln -sf /usr/sbin/nvim /usr/sbin/vi


.PHONY: sudo
visudo:
	@sed -i '/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^# //' /etc/sudoers


.PHONY: aur
aur: clean is-archlinux
	@sudo -u operator git clone https://aur.archlinux.org/yay.git
	@cd yay && sudo -u operator makepkg -si --noconfirm


.PHONY: zsh
zsh: is-archlinux
	@sudo -u operator yay --noconfirm --needed -Sy manjaro-zsh-config-git
	@chsh -s /bin/zsh operator


.PHONY: ssh
ssh: is-archlinux
	@sudo pacman -S --noconfirm openssh mosh
	@systemctl enable --now sshd.service
	@echo "You don't need to define a password for your new SSH key, but you can."
	@sleep 5s
	@sudo -u operator ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "operator@devshell"


.PHONY: install-base
install-base: is-archlinux
	@pacman --noconfirm --needed -S $(< ./packages/base.list)


.PHONY: install
install: locale upgrade operator neovim sudo aur zsh ssh install-base


.PHONY: stow
stow: clean
	@sudo -u operator stow */

