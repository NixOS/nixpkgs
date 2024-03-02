#include <atomic>
#include <cstdint>

int main()
{
  std::atomic_int x = {0};
  return !std::atomic_is_lock_free(&x);
}
