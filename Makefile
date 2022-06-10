path := .


.PHONY: is-archlinux
is-archlinux:
	@type pacman


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
	@if id "operator" &>/dev/null; then \
    	echo "operator is already here"; \
	else \
		useradd -m -g wheel operator; \
		echo "Which password do you want for operator user?"; \
		passwd operator; \
	fi


.PHONY: neovim
neovim: is-archlinux
	@pacman --noconfirm --needed -S neovim
	@if pacman -Qo vi &>/dev/null; then \
		pacman --noconfirm -R vi ; \
		ln -sf /usr/sbin/nvim /usr/sbin/vi; \
	fi


.PHONY: sudo
visudo:
	@sed -i '/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^# //' /etc/sudoers


.PHONY: aur
aur: is-archlinux
	@cd /tmp && \
	sudo -u operator git clone https://aur.archlinux.org/yay.git && \
	cd yay && \
	sudo -u operator makepkg -si --noconfirm


.PHONY: zsh
zsh: is-archlinux
	@cd /tmp && \
	sudo -u operator yay --noconfirm --needed -Sy manjaro-zsh-config-git && \
	chsh -s /bin/zsh operator


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
stow: 
	@sudo -u operator stow */

