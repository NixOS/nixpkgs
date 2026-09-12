# Desktop entries for `packages.json`'s `desktopEntries` from `makeDesktopItem`.
# Evaluation only sees the entries nixpkgs itself constructs; a consumer merges this
# with an index read from built packages, which uses the same schema.
{ lib }:

let
  # Discard context to serialize entries with store paths
  discardContext =
    value: if value == null then null else builtins.unsafeDiscardStringContext (toString value);

  splitSemicolons = value: lib.filter (item: item != "") (lib.splitString ";" value);

  # Keys that support localizing, like `Name[de]`
  localizedFields = {
    "Name" = "desktopName";
    "GenericName" = "genericName";
    "Comment" = "comment";
    "Keywords" = "keywords";
    "Icon" = "icon";
  };

  discardLocalized = lib.mapAttrs (
    _locale:
    lib.mapAttrs (
      field: value: if field == "keywords" then lib.map discardContext value else discardContext value
    )
  );

  # Parse a `.desktop` file: get the first section (up to the next `\n[`)
  parseDesktopEntry =
    text:
    let
      body = lib.splitString "\n" (lib.head (lib.splitString "\n[" text));
      # Also drops the `[Desktop Entry]` header (no `=`)
      kv = lib.filter (lib.hasInfix "=") body;
      attrs = lib.listToAttrs (
        lib.map (line: {
          name = lib.head (lib.splitString "=" line);
          value = lib.concatStringsSep "=" (lib.tail (lib.splitString "=" line));
        }) kv
      );
      localized = lib.foldl' (
        acc: key:
        let
          parts = lib.splitString "[" key;
          name = lib.head parts;
        in
        if lib.length parts != 2 || !(localizedFields ? ${name}) then
          acc
        else
          let
            locale = lib.removeSuffix "]" (lib.elemAt parts 1);
            field = localizedFields.${name};
          in
          acc
          // {
            ${locale} = (acc.${locale} or { }) // {
              ${field} = if field == "keywords" then splitSemicolons attrs.${key} else attrs.${key};
            };
          }
      ) { } (lib.attrNames attrs);
    in
    {
      type = attrs.Type or null;
      desktopName = attrs.Name or null;
      genericName = attrs.GenericName or null;
      comment = attrs.Comment or null;
      icon = attrs.Icon or null;
      keywords = splitSemicolons (attrs.Keywords or "");
      mimeTypes = splitSemicolons (attrs.MimeType or "");
      categories = splitSemicolons (attrs.Categories or "");
      noDisplay = attrs.NoDisplay or "" == "true";
      inherit localized;
    };

  # Unify `makeDesktopItem`'s passthru and rendered files
  entryOf =
    item:
    let
      entry =
        item.passthru.desktopEntry or (parseDesktopEntry (builtins.unsafeDiscardStringContext item.text));
    in
    {
      type = discardContext entry.type;
      desktopName = discardContext entry.desktopName;
      genericName = discardContext entry.genericName;
      comment = discardContext entry.comment;
      icon = discardContext entry.icon;
      keywords = lib.map discardContext entry.keywords;
      mimeTypes = lib.map discardContext entry.mimeTypes;
      categories = lib.map discardContext entry.categories;
      noDisplay = entry.noDisplay or null == true;
      localized = discardLocalized entry.localized;
    };

  # An item given as a plain path into `$src` carries nothing at eval time
  hasEntry = item: lib.isDerivation item && (((item.passthru or { }) ? desktopEntry) || item ? text);
in
{
  inherit parseDesktopEntry;

  # `desktopItems` may be a bare item rather than a list of them.
  entriesOf =
    package:
    lib.pipe
      (
        lib.toList (package.desktopItems or [ ])
        ++ lib.optional ((package.passthru or { }) ? desktopItem) package.passthru.desktopItem
      )
      [
        (lib.filter hasEntry)
        (lib.map entryOf)
      ];
}
