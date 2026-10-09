int main(int argc, char **)
{
  // A runtime size requires a libatomic call instead of a constant result.
  volatile bool lock_free = __atomic_is_lock_free(argc, nullptr);
  (void) lock_free;
  return 0;
}
