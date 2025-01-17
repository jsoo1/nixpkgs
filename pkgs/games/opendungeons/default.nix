{ lib, stdenv, fetchFromGitHub, ogre, cegui, boost, sfml, openal, cmake, ois, pkg-config }:

stdenv.mkDerivation rec {
  pname = "opendungeons";
  version = "unstable-2021-11-06";

  src = fetchFromGitHub {
    owner = "OpenDungeons";
    repo = "OpenDungeons";
    rev = "c180ed1864eab5fbe847d1dd5c5c936c4e45444e";
    sha256 = "0xf7gkpy8ll1h59wyaljf0hr8prg7p4ixz80mxqwcnm9cglpgn63";
  };

  patches = [
    ./cmakepaths.patch
    ./fix_link_date_time.patch
  ];

  # source/utils/StackTraceUnix.cpp:122:2: error: #error Unsupported architecture.
  postPatch = lib.optionalString (!stdenv.isx86_64) ''
    cp source/utils/StackTrace{Stub,Unix}.cpp
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ogre cegui boost sfml openal ois ];

  meta = with lib; {
    description = "An open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius";
    homepage = "https://opendungeons.github.io";
    license = with licenses; [ gpl3Plus zlib mit cc-by-sa-30 cc0 ofl cc-by-30 ];
    platforms = platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
