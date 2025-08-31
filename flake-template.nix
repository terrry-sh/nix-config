{
  description = "Home Manager configuration for terry";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    homeConfigurations."<USER>" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };

      modules = [
        {
          home = {
            username = "<USER>";
            homeDirectory = "/Users/<USER>";
            stateVersion = "25.05";

            # User packages
            packages = with pkgs; [
              # Development tools
              claude-code
              neovim
              zed-editor
              alacritty
              rust-analyzer

              # Terminal utilities
              tmux
              ripgrep
              eza
              fzf
              zoxide
              starship
              killport
              jq

              # Shells
              fish

              # Programming languages and tools
              python3
              uv
              micromamba
              cargo
              rustc
              go
              openjdk
              elan
              nodejs
              bun
              ruby
              php
              ocaml
              dune-release
              ocamlPackages.ocamlformat
              ocamlPackages.merlin
              futhark
              mlton

              # Build tools
              cmake
              autoconf
              automake
              libtool
              yarn
              capnproto
              capnproto-rust

              # Cloud and containers
              google-cloud-sdk
              awscli2
              docker
              docker-compose
              podman
              podman-compose
              kubectl
              kubernetes-helm
              terraform

              # Networking and utilities
              curl
              gemini-cli
              symfony-cli
              protobuf
              grpcurl
              terminal-notifier
              shellcheck
              yt-dlp

              # Applications
              slack
              firefox
              google-chrome
              raycast
              signal-desktop-bin
              obsidian
              anki-bin
              spotify
              spotifyd
              spotify-player
              vlc-bin
              discord
              inkscape
              mkcert
              coreutils-prefixed

              # Image processing
              imagemagick
              djvulibre

              # Fonts
              nerd-fonts.jetbrains-mono
              jetbrains-mono
              cascadia-code
              comic-neue
            ];

            # Environment variables
            sessionVariables = {
              EDITOR = "nvim";
            };

            # Home files
            file = {};
          };

          # Font configuration
          fonts.fontconfig.enable = true;

          # Program configurations
          programs = {
            home-manager.enable = true;

            vscode = {
              enable = true;

              extensions = with pkgs.vscode-extensions; [
                # Nix
                jnoortheen.nix-ide

                # Git
                eamodio.gitlens

                # Containers
                ms-azuretools.vscode-docker

                # Python
                ms-python.python
                ms-python.vscode-pylance
                ms-toolsai.jupyter

                # C/C++
                ms-vscode.cmake-tools
                llvm-vs-code-extensions.vscode-clangd

                # Java
                vscjava.vscode-gradle
                redhat.java

                # Rust
                rust-lang.rust-analyzer

                # Theme
                dracula-theme.theme-dracula

                # Other
                rooveterinaryinc.roo-cline
              ];

              userSettings = {
                # Editor settings
                "editor.fontSize" = 16;
                "editor.fontFamily" = "'JetBrains Mono', 'JetBrainsMono Nerd Font', 'Comic Neue'";
                "editor.multiCursorModifier" = "ctrlCmd";

                # Terminal settings
                "terminal.integrated.fontSize" = 14;
                "terminal.integrated.fontFamily" = "'Cascadia Code'";

                # Window settings
                "window.zoomLevel" = 1;
                "window.autoDetectColorScheme" = true;

                # Workbench settings
                "workbench.startupEditor" = "none";
                "workbench.colorTheme" = "Dracula Theme";
                "workbench.preferredDarkColorTheme" = "Dracula Theme";
                "workbench.preferredLightColorTheme" = "Default Light Modern";
                "workbench.iconTheme" = "material-icon-theme";

                # File settings
                "files.trimTrailingWhitespace" = true;
                "files.trimFinalNewlines" = true;
                "files.insertFinalNewline" = true;

                # Explorer settings
                "explorer.compactFolders" = false;

                # Diff settings
                "diffEditor.ignoreTrimWhitespace" = false;

                # Icon theme settings
                "material-icon-theme.activeIconPack" = "none";
                "material-icon-theme.folders.theme" = "classic";

                # Privacy settings
                "telemetry.telemetryLevel" = "off";
                "update.showReleaseNotes" = false;

                # Gitmoji settings
                "gitmoji.onlyUseCustomEmoji" = true;
                "gitmoji.addCustomEmoji" = [
                  {
                    emoji = "📦 NEW:";
                    code = ":package: NEW:";
                    description = "... Add new code/feature";
                  }
                  {
                    emoji = "👌 IMPROVE:";
                    code = ":ok_hand: IMPROVE:";
                    description = "... Improve existing code/feature";
                  }
                  {
                    emoji = "❌ REMOVE:";
                    code = ":x: REMOVE:";
                    description = "... Remove existing code/feature";
                  }
                  {
                    emoji = "🐛 FIX:";
                    code = ":bug: FIX:";
                    description = "... Fix a bug";
                  }
                  {
                    emoji = "📑 DOC:";
                    code = ":bookmark_tabs: DOC:";
                    description = "... Anything related to documentation";
                  }
                  {
                    emoji = "🤖 TEST:";
                    code = ":robot: TEST:";
                    description = "... Anything realted to tests";
                  }
                ];
              };
            };
          };
        }
      ];
    };
  };
}
