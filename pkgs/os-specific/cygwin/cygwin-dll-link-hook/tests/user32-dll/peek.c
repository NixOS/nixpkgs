#include <windows.h>

int peek()
{
				MSG msg;
				PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE);
}
