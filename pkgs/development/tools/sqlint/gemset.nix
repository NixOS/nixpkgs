{
  google-protobuf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QzP+LpAJEx2L7JtP/PrntaCi0b0YBh6KqvD9PVyDVjk=";
      type = "gem";
    };
    version = "3.25.5";
  };
  pg_query = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HMmVXHvOjlHhq8EfGVLj2dDxzUwWxYxW7HXVqvHP1pc=";
      type = "gem";
    };
    version = "4.2.3";
  };
  sqlint = {
    dependencies = [ "pg_query" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NpBCtT4eS3+aysrNJEyEEEnhzw1ZpmQK0n27BeWX9Bk=";
      type = "gem";
    };
    version = "0.3.0";
  };
}
