{
  description = "Pluvio, a desktop rainbox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        pnpm = pkgs.pnpm_9;

        pname = "Pluvio";
        version = "41ee51033e367ec2e8e9603ea2d12d44cd65cb97";

        src = pkgs.fetchFromGitHub {
          owner = "signet-marigold";
          repo = pname;
          rev = version;
          sha256 = "sha256-8fygAQ5PSZNGd0S12dOdoC0boWmVsHqqOK8ACHsMjYo=";
        };

        pluvio = pkgs.stdenv.mkDerivation {
          name = "Pluvio";
          inherit src;

          sourceRoot = "${src.name}/src-tauri";

          pnpmDeps = pnpm.fetchDeps {
            inherit pname version src;
            hash = "sha256-71zEHug/rsPgfQBYwJ2Dd7OVxv3AFv8HWgekCAvYsy0=";
          };

          pnpmRoot = "..";

          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            inherit src;
            sourceRoot = "${src.name}/src-tauri";
            hash = "sha256-OOH1kP41fyrcv1wvzG5FwM6LKA5ch5335/jwVc/RlKM=";
          };

          nativeBuildInputs = with pkgs; [
            rustPlatform.cargoSetupHook
            cargo
            rustc
            cargo-tauri.hook

            nodejs
            pnpm.configHook

            pkg-config
            wrapGAppsHook4
          ];

          buildInputs = with pkgs; [
            openssl
          ] ++ lib.optionals stdenv.hostPlatform.isLinux [
            dbus
            gtk3
            atk
            glib-networking
            webkitgtk_4_1
            alsa-lib
          ];

          preConfigure = ''
            # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
            # TODO: move frontend into its own drv
            chmod +w ..
          '';
        };
      in
      {
        packages.default = pluvio;

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cargo
            rustc
            nodejs
            pnpm_9
            pkg-config
            wrapGAppsHook4
            openssl
            dbus
            gtk3
            atk
            glib-networking
            webkitgtk_4_1
            alsa-lib
          ];
        };
      }
    );
}
