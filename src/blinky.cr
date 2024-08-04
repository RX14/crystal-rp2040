require "./bindings/*"
require "llvm/enums/atomic"

module Atomic::Ops
  @[Primitive(:load_atomic)]
  def self.load(ptr : T*, ordering : LLVM::AtomicOrdering, volatile : Bool) : T forall T
  end

  @[Primitive(:store_atomic)]
  def self.store(ptr : T*, value : T, ordering : LLVM::AtomicOrdering, volatile : Bool) : Nil forall T
  end
end

struct Int
  def ~
    self ^ -1
  end

  def bits_set?(mask) : Bool
    (self & mask) == mask
  end
end

struct UInt32
  def to_i
    self
  end
end

struct Bool
  def to_i
    self ? 1 : 0
  end
end

struct Enum
  def to_i
    value
  end
end

fun main2
  # LED = GPIO25

  RESETS::RESET.set(
    io_bank0: false,
    pads_bank0: false,
  )
  until RESETS::RESET_DONE.io_bank0 && RESETS::RESET_DONE.pads_bank0
  end

  IO_BANK0::GPIO25_CTRL.funcsel = :sio25
  SIO::GPIO_OE_SET.gpio_oe_set = 1_u32.unsafe_shl(25)
  SIO::GPIO_OUT_SET.gpio_out_set = 1_u32.unsafe_shl(25)
end
