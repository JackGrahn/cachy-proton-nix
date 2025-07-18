{ lib
, stdenv
, fetchurl
, zstd
}:

stdenv.mkDerivation {
  pname = "proton-cachyos";
  version = "1:10.0.20250714-1";

  src = fetchurl {
    url = "https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3/proton-cachyos-1%3A10.0.20250714-1-x86_64_v3.pkg.tar.zst";
    sha256 = "2075e02972ec37202c45238a56e141c80307fe9efc512ea5f69902d9c986066b";
  };

  nativeBuildInputs = [ zstd ];

  unpackPhase = ''
    runHook preUnpack
    tar -xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out
    
    # Find and copy the proton directory
    if [ -d "opt/proton-cachyos" ]; then
      cp -r opt/proton-cachyos/* $out/
    elif [ -d "usr/share/proton-cachyos" ]; then
      cp -r usr/share/proton-cachyos/* $out/
    elif [ -d "usr/share/steam/compatibilitytools.d/proton-cachyos" ]; then
      cp -r usr/share/steam/compatibilitytools.d/proton-cachyos/* $out/
    else
      # Fallback: copy everything
      cp -r * $out/
    fi
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "CachyOS Proton compatibility layer for Steam Play";
    homepage = "https://cachyos.org/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}