{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos";
  version = "10.0-20251107-slr";

  src = fetchzip {
    url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${finalAttrs.version}/proton-cachyos-${finalAttrs.version}-x86_64_v3.tar.xz";
    hash = "sha256-k/qGx1KMZbOsKH5YEiPWk1NOCXZ/N3t7hP45i2VOVWk=";
  };

    
  # Use a fixed name in the store path regardless of version
  name = "proton-cachyos";
  
  # Rebuild trigger: 2025-11-13-v4


  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. Use programs.steam.extraCompatPackages instead.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    # Create steamcompattool output and symlink everything, then copy compatibilitytool.vdf for modification
    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    # Patch compatibilitytool.vdf to use a fixed display name
    substituteInPlace $steamcompattool/compatibilitytool.vdf \
     --replace-fail "proton-cachyos-${finalAttrs.version}" "proton-cachyos"


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
})
