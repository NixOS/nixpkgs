{
  argon2 = {
    dependencies = ["ffi" "ffi-compiler"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g4qsdq072fyrsa7r0sg456dhrb017jmzdbnnzl2c80ha40bbmhg";
      type = "gem";
    };
    version = "2.1.1";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d2gqv8vry4ps0asb7nn1z4zxi3mcscy7yrim0npdd294ffyinvj";
      type = "gem";
    };
    version = "3.1.3";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  ffi-compiler = {
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2caqm9wqnbidcb8dj4wd3s902z15qmgxplwyfyqbwa0ydki7q1";
      type = "gem";
    };
    version = "1.0.1";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  unix-crypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wflipsmmicmgvqilp9pml4x19b337kh6p6jgrzqrzpkq2z52gdq";
      type = "gem";
    };
    version = "1.3.0";
  };
}
