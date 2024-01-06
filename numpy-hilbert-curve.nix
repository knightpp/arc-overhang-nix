{
  lib,
  python3,
  fetchPypi,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "numpy-hilbert-curve";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "numpy-hilbert-curve";
    inherit version;
    hash = "sha256-B0Xb1MFrJYwYA0LW31ffqZEQudmMhqhNkg8pr1zAcHs=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.numpy
  ];

  pythonImportsCheck = ["hilbert"];

  meta = with lib; {
    description = "Implements Hilbert space-filling curves for Python with numpy";
    homepage = "https://pypi.org/project/numpy-hilbert-curve/";
    license = licenses.mit;
    maintainers = with maintainers; [knightpp];
    mainProgram = "numpy-hilbert-curve";
  };
}
