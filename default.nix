{
  lib,
  stdenvNoCC,
  fetchzip,
  microarch ? "v3", # Default to v3 for backwards compatibility
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos-${microarch}";
  version = "10.0-20251222-slr";

  src = fetchzip {
    url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${finalAttrs.version}/proton-cachyos-${finalAttrs.version}-x86_64_${microarch}.tar.xz";
    hash = if microarch == "v3" 
      then "sha256-NmWQ3MonZ0HbtRWA48vcFN9vD0NqvebVDnlW7NrUu9k="
      else "sha256-f7fpSEB1LzK12CbYiim4jZbcuDUgQtzq3pU0YUfn7Iw="; # v4
  };

    
  # Use a fixed name in the store path regardless of version
  name = "proton-cachyos-${microarch}";
  
  # Rebuild trigger: 2025-11-14-v1


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
     --replace-fail "proton-cachyos-${finalAttrs.version}-x86_64_${microarch}" "proton-cachyos-${microarch}"


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
