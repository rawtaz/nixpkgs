{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, sortedcontainers
, async_generator
, idna
, outcome
, contextvars
, pytest
, pyopenssl
, trustme
, sniffio
}:

buildPythonPackage rec {
  pname = "trio";
  version = "0.7.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0df152qnj4xgxrxzd8619f8h77mzry7z8sp4m76fi21gnrcr297n";
  };

  checkInputs = [ pytest pyopenssl trustme ];
  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  checkPhase = ''
    py.test -k 'not test_getnameinfo and not test_SocketType_resolve and not test_getprotobyname'
  '';
  propagatedBuildInputs = [
    attrs
    sortedcontainers
    async_generator
    idna
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.7") [ contextvars ];

  meta = {
    description = "An async/await-native I/O library for humans and snake people";
    homepage = https://github.com/python-trio/trio;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
