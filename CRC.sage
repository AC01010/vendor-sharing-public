initial_bits = ceil(log(63,2)*244)
total_bits = initial_bits
checksum_bits = 12
tolerance = 3

F.<x> = GF(2)[]
g = 0

while g==0:
    for term in filter(lambda x: x.degree()<=checksum_bits+tolerance, divisors(x^total_bits-1)):
        d = term.degree()
        if d>=checksum_bits and d<=checksum_bits+tolerance:
            g = term
            if total_bits%2==0:
                g = 0
    if g==0:
        total_bits-=1

print(f"Found valid polynomial of degree {g.degree()}: {g}")
print(f"{initial_bits-total_bits} bits have been wasted.\n")

C = codes.CyclicCode(generator_pol=g, length=total_bits)
E = codes.encoders.CyclicCodePolynomialEncoder(C)

def prepare_msg(m, pad_len):
    l = []
    for c in m:
        l.append(alphabet.index(c))
    binRet = ZZ(l, base=63).digits(base=2)
    while len(binRet)<=pad_len-1:
        binRet.append(0)
    return F([binRet])

def encode_msg(msg):
    try:
        m = prepare_msg(msg, total_bits-g.degree())
        enc = E.encode(m)
        b63Ret = ZZ(list(enc), base=2).digits(base=63)
        return("".join([alphabet[i] for i in b63Ret]))
    except Exception as e:
        print("Invalid message. Message too long or contains invalid characters.")

def decode_msg(enc_msg):
    try:
        m = prepare_msg(enc_msg, total_bits-g.degree())
        enc = E.unencode_nocheck(m)
        b63Ret = ZZ(list(enc), base=2).digits(base=63)
        ret = "".join([alphabet[i] for i in b63Ret])
        if encode_msg(ret[1:]) != enc_msg:
            raise Exception(1)
        return("".join([alphabet[i] for i in b63Ret]))
    except Exception as e:
        if e==1:
            print("Incorrect CRC")
        else:
            print("Invalid ciphertext. Ciphertext too long or contains invalid characters.")
            
print(encode_msg(message))
