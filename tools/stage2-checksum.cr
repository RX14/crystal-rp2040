require "digest"
require "crystal/elf"

File.copy(ARGV[0], ARGV[1])
File.open(ARGV[1], "r+") do |f|
  elf = Crystal::ELF.new(f)
  elf.read_section?(".boot2") do |section, io|
    raise "Invalid section size" unless section.size == 256

    bytes = Bytes.new(256 - 4) # 256 bytes minus checksum size
    io.read_fully(bytes)

    bytes.map!(&.bit_reverse)

    crc = Digest::CRC32.update(bytes, 0)
    crc ^= 0xFFFFFFFF_u32
    crc = crc.bit_reverse

    p crc.to_s(16)

    # We force synchronous behaviour here because IO::Buffered has bad behaviour
    io.pos = section.offset + 256 - 4
    io.write_bytes(crc, IO::ByteFormat::LittleEndian)
    io.flush
  end
end
