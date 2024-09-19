# from: https://github.com/Jovian-Experiments/Jovian-NixOS
{ pkgs }:
pkgs.python3.pkgs.buildPythonPackage rec {
  pname = "decky-loader";
  version = "3.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "SteamDeckHomebrew";
    repo = "decky-loader";
    rev = "v${version}";
    hash = "sha256-XvdVfgmP+XMMjIQ2BKojInYIeHu4KAiiRaGGgt8Ivwg=";
  };

  pyproject = true;

  pnpmDeps = pkgs.pnpm.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/frontend";
    hash = "sha256-xPLciBj5Pjo9BqlD7YPtx1D3U2/BZQy5tuW8uA/H/KA=";
  };

  pnpmRoot = "frontend";

  nativeBuildInputs = [
    pkgs.nodejs
    pkgs.pnpm.configHook
  ];

  preBuild = ''
    cd frontend
    pnpm build
    cd ../backend
  '';

  build-system = with pkgs.python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with pkgs.python3.pkgs; [
    aiohttp
    aiohttp-cors
    aiohttp-jinja2
    certifi
    multidict
    packaging
    setproctitle
    watchdog
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      pkgs.lib.makeBinPath [
        pkgs.coreutils
        pkgs.psmisc
      ]
    }"
  ];

  passthru.python = pkgs.python3;

  meta = with pkgs.lib; {
    description = "A plugin loader for the Steam Deck";
    homepage = "https://github.com/SteamDeckHomebrew/decky-loader";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
