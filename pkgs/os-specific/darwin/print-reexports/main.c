/**
 * Display the list of re-exported libraries from a TAPI v2 .tbd file, one per
 * line on stdout.
 *
 * TAPI files are the equivalent of library files for the purposes of linking.
 * Like dylib files, they may re-export other libraries. In upstream usage
 * these refer to the absolute paths of dylibs, and are resolved to .tbd files
 * in combination with the syslibroot option. In nixpkgs, the .tbd files refer
 * directly to other .tbd files without a syslibroot. Note that each .tbd file
 * contains an install name, so the re-exported path does not affect the final
 * result.
 *
 * In nixpkgs each framework is a distinct store path and some frameworks
 * re-export other frameworks. The re-exported names are rewritten to refer to
 * the store paths of dependencies via textual substitution. This utility is
 * used to emit every file that is listed as a re-exported library, which
 * allows the framework builder to verify their existence.
 */

#include <stdio.h>
#include <sys/errno.h>
#include <yaml.h>

#define LOG(str, ...) fprintf(stderr, "%s", str)

#define LOGF(...) fprintf(stderr, __VA_ARGS__)

static yaml_node_t *get_mapping_entry(yaml_document_t *document, yaml_node_t *mapping, const char *name) {
  if (!mapping) {
    fprintf(stderr, "get_mapping_entry: mapping is null\n");
    return NULL;
  }

  for (
      yaml_node_pair_t *pair = mapping->data.mapping.pairs.start;
      pair < mapping->data.mapping.pairs.top;
      ++pair
  ) {
    yaml_node_t *key = yaml_document_get_node(document, pair->key);

    if (!key) {
      LOGF("key (%d) is null\n", pair->key);
      return NULL;
    }

    if (key->type != YAML_SCALAR_NODE) {
      LOG("get_mapping_entry: key is not a scalar\n");
      return NULL;
    }

    if (strncmp((const char *)key->data.scalar.value, name, key->data.scalar.length) != 0) {
      continue;
    }

    return yaml_document_get_node(document, pair->value);
  }

  return NULL;
}

static int emit_reexports_v2(yaml_document_t *document) {
  yaml_node_t *root = yaml_document_get_root_node(document);

  yaml_node_t *exports = get_mapping_entry(document, root, "exports");

  if (!exports) {
    return 1;
  }

  if (exports->type != YAML_SEQUENCE_NODE) {
    LOG("value is not a sequence\n");
    return 0;
  }

  for (
      yaml_node_item_t *export = exports->data.sequence.items.start;
      export < exports->data.sequence.items.top;
      ++export
  ) {
    yaml_node_t *export_node = yaml_document_get_node(document, *export);

    yaml_node_t *reexports = get_mapping_entry(document, export_node, "re-exports");

    if (!reexports) {
      continue;
    }

    if (reexports->type != YAML_SEQUENCE_NODE) {
      LOG("re-exports is not a sequence\n");
      return 0;
    }

    for (
        yaml_node_item_t *reexport = reexports->data.sequence.items.start;
        reexport < reexports->data.sequence.items.top;
        ++reexport
    ) {
      yaml_node_t *val = yaml_document_get_node(document, *reexport);

      if (val->type != YAML_SCALAR_NODE) {
        LOG("item is not a scalar\n");
        return 0;
      }

      fwrite(val->data.scalar.value, val->data.scalar.length, 1, stdout);
      putchar('\n');
    }
  }

  return 1;
}

static int emit_reexports_v4(yaml_document_t *document) {
  yaml_node_t *root = yaml_document_get_root_node(document);
  yaml_node_t *reexports = get_mapping_entry(document, root, "reexported-libraries");

  if (!reexports) {
    return 1;
  }

  if (reexports->type != YAML_SEQUENCE_NODE) {
    LOG("value is not a sequence\n");
    return 0;
  }

  for (
      yaml_node_item_t *entry = reexports->data.sequence.items.start;
      entry < reexports->data.sequence.items.top;
      ++entry
  ) {
    yaml_node_t *entry_node = yaml_document_get_node(document, *entry);

    yaml_node_t *libs = get_mapping_entry(document, entry_node, "libraries");

    if (!libs) {
      continue;
    }

    if (libs->type != YAML_SEQUENCE_NODE) {
      LOG("libraries is not a sequence\n");
      return 0;
    }

    for (
        yaml_node_item_t *lib = libs->data.sequence.items.start;
        lib < libs->data.sequence.items.top;
        ++lib
    ) {
      yaml_node_t *val = yaml_document_get_node(document, *lib);

      if (val->type != YAML_SCALAR_NODE) {
        LOG("item is not a scalar\n");
        return 0;
      }

      fwrite(val->data.scalar.value, val->data.scalar.length, 1, stdout);
      putchar('\n');
    }
  }

  return 1;
}

int main(int argc, char **argv) {
  int result = 0;

  if (argc != 2) {
    fprintf(stderr, "Invalid usage\n");
    result = 2;
    goto done;
  }

  FILE *f = fopen(argv[1], "r");
  if (!f) {
    perror("opening input file");
    result = errno;
    goto done;
  }

  yaml_parser_t yaml_parser;
  if (!yaml_parser_initialize(&yaml_parser)) {
    fprintf(stderr, "Failed to initialize yaml parser\n");
    result = 1;
    goto err_file;
  }

  yaml_parser_set_input_file(&yaml_parser, f);

  yaml_document_t yaml_document;

  if(!yaml_parser_load(&yaml_parser, &yaml_document)) {
    fprintf(stderr, "Failed to load yaml file\n");
    result = 1;
    goto err_yaml;
  }

  // Try both, only fail if one reports an error.  A lack of re-exports is not
  // considered an error.
  int ok = 1;
  ok = ok && emit_reexports_v2(&yaml_document);
  ok = ok && emit_reexports_v4(&yaml_document);

  result = !ok;

err_yaml:
  yaml_parser_delete(&yaml_parser);

err_file:
  fclose(f);

done:
  return result;
}
