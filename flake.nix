{
  description = "Small, fullscreen SSH askpass GUI using GTK+2";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          mkSshAskpass = { variant, imageFile, description }:
            pkgs.stdenv.mkDerivation {
              pname = "ssh-askpass-fullscreen-${variant}";
              version = "1.3";

              src = ./.;

              nativeBuildInputs = [
                pkgs.autoreconfHook
                pkgs.pkg-config
              ];
              buildInputs = [
                pkgs.gtk2
                pkgs.openssh
              ];

              postPatch = ''
                cp src/${imageFile} src/background.png
              '';

              strictDeps = true;

              meta = {
                homepage = "https://github.com/x13-me/ssh-askpass-fullscreen";
                broken = pkgs.stdenv.hostPlatform.isDarwin;
                inherit description;
                license = [ pkgs.lib.licenses.gpl2Plus ];
                mainProgram = "ssh-askpass-fullscreen";
                maintainers = [ ];
                platforms = pkgs.lib.platforms.unix;
              };
            };

          variants = {
            default = mkSshAskpass {
              variant = "default";
              imageFile = "default.png";
              description = "Small, fullscreen SSH askpass GUI using GTK+2";
            };
            "256" = mkSshAskpass {
              variant = "256";
              imageFile = "256.png";
              description = "Small, fullscreen SSH askpass GUI using GTK+2 (256-colour)";
            };
            mono = mkSshAskpass {
              variant = "mono";
              imageFile = "mono.png";
              description = "Small, fullscreen SSH askpass GUI using GTK+2 (monochrome)";
            };
          };
        in
        variants // { default = variants.default; }
      );

      overlays.default = final: _prev: {
        ssh-askpass-fullscreen = self.packages.${final.system}.default;
        ssh-askpass-fullscreen-256 = self.packages.${final.system}."256";
        ssh-askpass-fullscreen-mono = self.packages.${final.system}.mono;
      };
    };
}