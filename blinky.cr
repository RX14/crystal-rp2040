# LED = GPIO25

IO_BANK0_BASE = 0x40014000_u64
GPIO25_CTRL   = Pointer(UInt32).new(IO_BANK0_BASE &+ 0x0cc)

PADS_BANK0_BASE = 0x4001c000_u64
GPIO25          = Pointer(UInt32).new(PADS_BANK0_BASE &+ 0x68)

SIO_BASE = 0xd0000000_u64
GPIO_OUT = Pointer(UInt32).new(SIO_BASE &+ 0x010)
GPIO_OE  = Pointer(UInt32).new(SIO_BASE &+ 0x020)

RESETS_BASE = 0x4000c000_u64
RESET       = Pointer(UInt32).new(RESETS_BASE &+ 0)
RESET_DONE  = Pointer(UInt32).new(RESETS_BASE &+ 0x8)

struct Int
  def ~
    self ^ -1
  end
end

fun main2
  reset = 0b1110000111000000000000001_u32
  RESET.value = reset
  while (RESET_DONE.value & ~reset) == 0
  end
  GPIO25.value = 0b01010000
  GPIO25_CTRL.value = 5
  GPIO_OE.value = 1u32.unsafe_shl(25)
  GPIO_OUT.value = 1u32.unsafe_shl(25)
end
