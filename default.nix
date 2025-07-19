{ lib
, stdenvNoCC
, fetchurl
, zstd
}:

stdenvNoCC.mkDerivation {
  pname = "proton-cachyos";
  version = "1:10.0.20250714-1";

  src = fetchurl {
    url = "https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3/proton-cachyos-1%3A10.0.20250714-1-x86_64_v3.pkg.tar.zst";
    sha256 = "2075e02972ec37202c45238a56e141c80307fe9efc512ea5f69902d9c986066b";
  };

  nativeBuildInputs = [ zstd ];

  outputs = [
    "out"
    "steamcompattool"
  ];

  unpackPhase = ''
    runHook preUnpack
    tar -xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    
    # Make it impossible to add to an environment. Use programs.steam.extraCompatPackages instead.
    echo "proton-cachyos should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    # Extract the proton directory for steamcompattool output
    if [ -d "usr/share/steam/compatibilitytools.d/proton-cachyos" ]; then
      proton_dir="usr/share/steam/compatibilitytools.d/proton-cachyos"
    elif [ -d "opt/proton-cachyos" ]; then
      proton_dir="opt/proton-cachyos"
    elif [ -d "usr/share/proton-cachyos" ]; then
      proton_dir="usr/share/proton-cachyos"
    else
      echo "Could not find proton directory"
      exit 1
    fi

    mkdir $steamcompattool
    cp -r "$proton_dir"/* $steamcompattool/
    
    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      CachyOS Proton compatibility layer for Steam Play.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://cachyos.org/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}