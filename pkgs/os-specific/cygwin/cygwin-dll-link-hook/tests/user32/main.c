#include <windows.h>

int main()
{
				MSG msg;
				PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE);
}
