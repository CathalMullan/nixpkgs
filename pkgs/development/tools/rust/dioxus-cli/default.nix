{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, rustfmt
, cacert
, openssl
, darwin
, nix-update-script
, testers
, dioxus-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.6.0-alpha.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LG0uMA+/oCNbF7ocHfh1rGKqe6Jrk9i1MMa1ADtbSY8=";
  };

  cargoHash = "sha256-p6qoczeQQ4d94kjSLaF7Z8G6LzK41296r1Dhk5alqNQ=";
  cargoBuildFeatures = [ "wasm-opt" ];

  nativeBuildInputs = [ pkg-config cacert ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  OPENSSL_NO_VENDOR = 1;

  nativeCheckInputs = [ rustfmt ];

  checkFlags = [
    # requires network access
    "--skip=serve::proxy::test"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = dioxus-cli; };
  };

  meta = with lib; {
    homepage = "https://dioxuslabs.com";
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    changelog = "https://github.com/DioxusLabs/dioxus/releases";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio cathalmullan ];
    mainProgram = "dx";
  };
}
