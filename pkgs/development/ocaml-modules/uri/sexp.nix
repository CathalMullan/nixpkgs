{
  lib,
  ocaml,
  buildDunePackage,
  uri,
  ounit,
  ppx_sexp_conv,
  sexplib0,
}:

if lib.versionOlder ocaml.version "4.04" then
  throw "uri-sexp is not available for OCaml ${ocaml.version}"
else

  buildDunePackage {
    pname = "uri-sexp";
    inherit (uri) version src meta;

    duneVersion = "3";

    checkInputs = [ ounit ];
    propagatedBuildInputs = [
      ppx_sexp_conv
      sexplib0
      uri
    ];
    doCheck = lib.versionAtLeast ocaml.version "4.08";
  }
