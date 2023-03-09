{ fetchCrate
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "paging-calculator";
  version = "0.1.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9DbpfJbarWXYGNzTqfHHSaKFqSJ59E/VhOhuMUWk8ho=";
  };

  cargoHash = "sha256-IfOhJwR5eRHeeAbEZ8zeUVojQXtrYHdzAeht/lvdlUQ=";

  meta = {
    description = "CLI utility that helps calculating page table indices from a virtual address";
    longDescription = ''
      paging-calculator is a CLI utility written in Rust that helps you find the indices that a virtual
      address will have on different architectures or paging implementations.

      It takes a (virtual) address in hexadecimal format and shows you which index will be used for
      what page-table level. It can be installed with $ cargo install paging-calculator.
    '';
    homepage = "https://github.com/phip1611/paging-calculator";
    changelog = "https://github.com/phip1611/paging-calculator/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}
