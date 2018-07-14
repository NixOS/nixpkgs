package nixos

import "testing"

func TestAdd(t *testing.T) {

	if want, got := 3, Add(1, 2); want != got {
		t.Errorf("Add(1, 2): want %d got %d", want, got)
	}
}
