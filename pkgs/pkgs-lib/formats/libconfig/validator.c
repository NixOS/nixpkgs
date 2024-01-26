//    Copyright (C) 2005-2023  Mark A Lindner, ckie
//    SPDX-License-Identifier: LGPL-2.1-or-later
#include <stdio.h>
#include <libconfig.h>
int main(int argc, char **argv)
{
  config_t cfg;
  config_init(&cfg);
  if (argc != 2)
  {
    fprintf(stderr, "USAGE: validator <path-to-validate>");
  }
  if(! config_read_file(&cfg, argv[1]))
  {
    fprintf(stderr, "[libconfig] %s:%d - %s\n", config_error_file(&cfg),
            config_error_line(&cfg), config_error_text(&cfg));
    config_destroy(&cfg);
    return 1;
  }
  printf("[libconfig] validation ok\n");
}