# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # To enable use of Nvidia Drivers
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Not validated as necessary... for monitor control
  boot.kernelModules = [ "i2c-dev" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_NZ.UTF-8";
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ mozc ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    dpi = 96;
    layout =  "us";
    xkbOptions = "shift:both_capslock";
    videoDrivers = [ "nvidia" ];
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";

  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    dmenu
    i3status
    i3lock
    i3blocks
    polybarFull
  ];

  # Add i3 (with gaps)
  environment.pathsToLink = [ "/libexec" ]; # due to hardcoded paths in i3blocks, we need to link
  environment.variables = {
    PYTHONPATH = "/home/mark/.local/lib/python3.8/site-packages";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enabled to support Nvidia-docker
  hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.mark = {
    isNormalUser = true;
    group = "mark";
    shell = pkgs.zsh;
    extraGroups = [
      "users"
      "wheel"
      "sudo"
      "docker"
     ]; # Enable ‘sudo’ for the user.
  };
  users.extraGroups.mark.gid = 1000;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nixpkgs.config.allowBroken = true; # For PCL

  environment.systemPackages = with pkgs; [
    (python38.withPackages(ps: [
      ps.ipython
      ps.numpy
      ps.opencv4
      ps.requests
    ]))
    arandr                       # Monitor manager
    audacity                     # Audio editing software
    awscli                       # Amazon web services CLI interface
    black                        # The uncompromising Python code formatter
    blender
    cargo                        # Downloads your Rust project's dependencies and builds your project
    clang-tools
    clipit                       # Lightweight GTK Clipboard Manager
    compton                      # Fancy effects for your window manager
    ddcutil                      # Monitor brightness control
    docker
    docker-compose
    electrum                     # A lightweight Bitcoin wallet
    ffmpeg
    firefox
    gcc
    ghostwriter                  # Markdown editor
    gifsicle                     # Tool for creating and editing GIF images
    gimp
    git
    git-lfs                      # Git extension for versioning large files
    gitAndTools.gitflow          # Extend git with the Gitflow branching model
    gnome3.gnome-tweak-tool
    gnome3.meld                  # File diff tool
    gnumake
    gparted                      # Graphical disk partitioning tool
    hanazono                     # Japanese font
    hsetroot                     # Program to set the color of the background
    htop
    ibus-engines.mozc            # Japanese language input
    inkscape
    jq                           # Command-line JSON parser
    labelImg                     # graphical image annotation tool
    linuxPackages.ddcci-driver   # Monitor brightness control
    ltunify                      # Tool for working with Logitech Unifying receivers and devices
    lxappearance
    meshlab
    nvidia-docker
    oh-my-zsh
    opencv
    openscad
    pavucontrol
    pcl                          # Marked as broken, requires allowBroken = true;
    pdfsam-basic                 # Multi-platform software designed to extract pages, split, merge, mix and rotate PDF files
    pdftk                        # Tool for removing passwords from pdf-files
    peek                         # GIF screen recorder
    ranger                       # Terminal based file-browser/previewer
    rustc                        # A safe, concurrent, practical language
    shellcheck                   # Shell script analysis tool
    sqlitebrowser                # GUI for browsing sqlite database files
    sublime-merge
    sublime3
    tdesktop                     # Telegram Desktop
    termdown                     # Countdown timer for the terminal
    unzip
    up                           # tool for writing Linux pipes with instant live preview
    vim
    volumeicon                   # A lightweight volume control that sits in your systray
    wget
    wireshark
    xclip                        # Tool to access the X clipboard from a console application
    xdotool
    zip
    zsh
  ];

  fonts.fonts = with pkgs; [
    dejavu_fonts
    ipafont                      # Japanese font
    kochi-substitute             # Japanese font
    liberation_ttf
    migu                         # Japanese font
    noto-fonts
    noto-fonts-cjk               # CJK glyphs for noto
    noto-fonts-emoji
    rounded-mgenplus             # Japanese font
    source-han-sans-japanese     # Japanese sans font
    source-han-serif-japanese    # Japanese serif font
    terminus_font
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Terminus Regular"
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "Noto Sans Regular"
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.dconf.enable = true;
  programs.nm-applet.enable = true;
  programs.seahorse.enable = true;
  programs.zsh = {
    enable = true;
    promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
    interactiveShellInit = ''
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      # export ZSH_THEME="simple"
      export ZSH_THEME="philips"
      plugins=(git)
      source $ZSH/oh-my-zsh.sh
    '';
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.blueman.enable = true;
  services.openssh.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  services.udev.extraRules = ''
  KERNEL=="i2c-[0-9]*", MODE="0666" GROUP="wheel"
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

