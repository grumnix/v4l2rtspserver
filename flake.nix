{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    v4l2rtspserver_src.url = "git+https://github.com/mpromonet/v4l2rtspserver.git?submodules=1";
    v4l2rtspserver_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, v4l2rtspserver_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = v4l2rtspserver;

          v4l2rtspserver = pkgs.stdenv.mkDerivation rec {
            pname = "v4l2rtspserver";
            version = "0.3.7-${v4l2rtspserver_src}.shortRev";

            src = v4l2rtspserver_src;

            nativeBuildInputs = with pkgs; [
              pkg-config
              cmake
              git
            ];

            buildInputs = with pkgs; [
              alsa-lib
              live555
              log4cpp
              openssl
            ];
          };
        };
      }
    );
}
