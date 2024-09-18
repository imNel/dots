with import <nixpkgs> {};

writeShellScriptBin "steamos-session-select" ''
  # https://github.com/ValveSoftware/steam-for-linux/issues/9495#issuecomment-2074614285
  # shutdown steam which will kick you back to the display manager
  steam -shutdown
''
