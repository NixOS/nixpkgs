const {increment,decrement} = require('./index');

describe('incrementing', () => {
  it('should do that', () => {
    expect(increment(1)).toBe(2);
  });
});

describe('decrementing', () => {
  it('should do that', () => {
    expect(decrement(1)).toBe(0);
  });
});
