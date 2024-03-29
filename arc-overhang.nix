{
  lib,
  fetchFromGitHub,
  callPackage,
  python3Packages,
}: let
  numpy-hilbert-curve = callPackage (import ./numpy-hilbert-curve.nix) {};
in
  python3Packages.buildPythonApplication {
    pname = "arc-overhang";
    version = "unstable-2023-12-18";
    pyproject = false;

    src = fetchFromGitHub {
      owner = "nicolai-wachenschwan";
      repo = "arc-overhang-prusaslicer-integration";
      rev = "168ff8a2d5d9e1eca2ccabb7bab4ac2729aebe0d";
      hash = "sha256-BWZx2iO9xQKjXB6RS8VCS2rfASjp7rgfu1NPRDwjJak=";
    };

    propagatedBuildInputs =
      [
        numpy-hilbert-curve
      ]
      ++ builtins.attrValues {
        inherit
          (python3Packages)
          shapely
          numpy
          matplotlib
          ;
      };

    installPhase = ''
      runHook preInstall

      # substitute does not work since the comment is before shebang
      #
      # substituteInPlace prusa_slicer_post_processing_script.py \
      #   --replace '/usr/bin/python' ${python3Packages.python}/bin/python
      # install -D --mode +x prusa_slicer_post_processing_script.py $out/bin/arc-overhang.py

      mkdir -p $out/bin/
      echo "#!${python3Packages.python}/bin/python" >> $out/bin/arc-overhang.py
      cat prusa_slicer_post_processing_script.py >> $out/bin/arc-overhang.py
      chmod +x $out/bin/arc-overhang.py

      runHook postInstall
    '';

    meta = with lib; {
      description = "A 3D printer slicing algorithm that lets you print 90° overhangs without support material";
      homepage = "https://github.com/nicolai-wachenschwan/arc-overhang-prusaslicer-integration";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [knightpp];
      mainProgram = "arc-overhang";
      platforms = platforms.all;
    };
  }
