/*
 * Copyright (C) 2022 koolkdev
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

#include <boost/program_options.hpp>
#include <cstdio>
#include <filesystem>
#include <format>
#include <fstream>
#include <iostream>
#include <memory>
#include <vector>

#include <wfslib/wfslib.h>
#include "../../wfslib/src/area.h"                   // TOOD: Public header?
#include "../../wfslib/src/free_blocks_allocator.h"  // TOOD: Public header?

std::string inline prettify_path(const std::filesystem::path& path) {
  return "/" + path.generic_string();
}

constexpr int blocks_counts[] = {0, 3, 6, 10, 14, 18, 22, 26};

void dumpArea(int depth, const std::filesystem::path& path, const std::shared_ptr<const Area>& area) {
  std::string padding(depth, '\t');
  std::cout << std::format("{}Area {} [0x{:08x}-0x{:08x}]:\n", padding, prettify_path(path), area->BlockNumber(),
                           area->AbsoluteBlockNumber(area->BlocksCount()));

  padding += '\t';
  auto allocator = throw_if_error(area->GetFreeBlocksAllocator());
  std::cout << std::format("{}Free blocks: 0x{:08x}\n", padding, allocator->header()->free_blocks_count.value());
  std::cout << std::format("{}Free metadata blocks: 0x{:08x}\n", padding,
                           allocator->header()->free_metadata_blocks_count.value());
  std::cout << std::format("{}Free metadata block: 0x{:08x}\n", padding,
                           area->AbsoluteBlockNumber(allocator->header()->free_metadata_block.value()));
  std::cout << std::format("{}Unknown: 0x{:08x}\n", padding, allocator->header()->unknown.value());

  std::map<uint32_t, uint32_t> free_ranges;
  for (const auto& [tree_block_number, free_tree] : allocator->tree()) {
    int size = 0;
    for (const auto& free_tree_per_size : free_tree) {
      for (const auto& [block_number, blocks_count] : free_tree_per_size) {
        free_ranges[area->AbsoluteBlockNumber(block_number)] =
            area->AbsoluteBlockNumber(block_number + (static_cast<int>(blocks_count) + 1) * (1 << blocks_counts[size]));
      }
      ++size;
    }
  }
  // Coalesce
  auto current = free_ranges.begin();
  while (current != free_ranges.end()) {
    auto next = current;
    ++next;
    if (next == free_ranges.end())
      break;
    if (current->second == next->first) {
      current->second = next->second;
      free_ranges.erase(next);
    } else {
      ++current;
    }
  }
  std::cout << std::format("{}Free ranges:\n", padding);
  padding += '\t';
  for (const auto& [start_block, end_block] : free_ranges) {
    std::cout << std::format("{}[0x{:08x}-0x{:08x}]\n", padding, start_block, end_block);
  }
}

void dumpdir(int depth, const std::shared_ptr<Directory>& dir, const std::filesystem::path& path) {
  if (dir->IsQuota()) {
    dumpArea(depth, path, dir->area());
    depth += 1;
  }
  for (auto [name, item_or_error] : *dir) {
    auto const npath = path / name;
    try {
      auto item = throw_if_error(item_or_error);
      if (item->IsDirectory())
        dumpdir(depth, std::dynamic_pointer_cast<Directory>(item), npath);
    } catch (const WfsException& e) {
      std::cout << std::format("Error: Failed to dump {} ({})\n", prettify_path(npath), e.what());
    }
  }
}

int main(int argc, char* argv[]) {
  try {
    boost::program_options::options_description desc("Allowed options");
    std::string wfs_path;
    desc.add_options()("help", "produce help message")("input", boost::program_options::value<std::string>(),
                                                       "input file")(
        "otp", boost::program_options::value<std::string>(), "otp file")(
        "seeprom", boost::program_options::value<std::string>(), "seeprom file (required if usb)")(
        "mlc", "device is mlc (default: device is usb)")("usb", "device is usb");

    boost::program_options::variables_map vm;
    boost::program_options::store(boost::program_options::parse_command_line(argc, argv, desc), vm);
    boost::program_options::notify(vm);

    bool bad = false;
    if (!vm.count("input")) {
      std::cerr << "Missing input file (--input)" << std::endl;
      bad = true;
    }
    if (!vm.count("otp")) {
      std::cerr << "Missing otp file (--otp)" << std::endl;
      bad = true;
    }
    if ((!vm.count("seeprom") && !vm.count("mlc"))) {
      std::cerr << "Missing seeprom file (--seeprom)" << std::endl;
      bad = true;
    }
    if (vm.count("mlc") + vm.count("usb") > 1) {
      std::cerr << "Can't specify both --mlc and --usb" << std::endl;
      bad = true;
    }
    if (vm.count("help") || bad) {
      std::cout << "Usage: wfs-extract --input <input file> --output <output directory> --otp <opt path> [--seeprom "
                   "<seeprom path>] [--mlc] [--usb] [--dump-path <directory to dump>] [--verbose]"
                << std::endl;
      std::cout << desc << "\n";
      return 1;
    }

    std::vector<std::byte> key;
    std::unique_ptr<OTP> otp;
    // open otp
    try {
      otp.reset(OTP::LoadFromFile(vm["otp"].as<std::string>()));
    } catch (std::exception& e) {
      std::cerr << "Failed to open OTP: " << e.what() << std::endl;
      return 1;
    }

    if (vm.count("mlc")) {
      // mlc
      key = otp->GetMLCKey();
    } else {
      // usb
      std::unique_ptr<SEEPROM> seeprom;
      try {
        seeprom.reset(SEEPROM::LoadFromFile(vm["seeprom"].as<std::string>()));
      } catch (std::exception& e) {
        std::cerr << "Failed to open SEEPROM: " << e.what() << std::endl;
        return 1;
      }
      key = seeprom->GetUSBKey(*otp);
    }
    auto device = std::make_shared<FileDevice>(vm["input"].as<std::string>(), 9);
    Wfs::DetectDeviceSectorSizeAndCount(device, key);
    std::cout << "Allocator state:" << std::endl;
    dumpdir(0, throw_if_error(Wfs(device, key).GetRootArea()->GetRootDirectory()), {});
    std::cout << "Done!" << std::endl;
  } catch (std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
  return 0;
}
