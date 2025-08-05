{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = let
      pP = pkgs.perlPackages;
    in
      pkgs.perlPackages.buildPerlPackage rec {
        pname = "SignControl";
        version = "0.1";

        src = ./.;

        propagatedBuildInputs = [pP.DigestCRC pP.ModuleBuild];
        nativeBuildInputs = [pkgs.shortenPerlShebang];

        postInstall = ''
          shortenPerlShebang $out/bin/signcontrol
        '';
      };
    devShells.${system}.default =
      pkgs.mkShell
      {
        nativeBuildInputs = [
          (pkgs.perl.withPackages
            (x: [
              x.DigestCRC
              x.ModuleBuild
            ]))
        ];
      };
  };
}
