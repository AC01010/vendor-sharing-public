str = "afy9wclpwiyxosaclpwiy0tplclpwiyf3t.epir.site"
str = str.split(".")[0]
binId = str[0]
crc = str[-3:]
str = str[1:-3]
info = []
while len(str)>0:
    next = str[0:10]
    new_info = {}
    new_info["execID"] = next[0:4]
    new_info["installDate"] = next[4:7]
    new_info["ram"] = next[7]
    new_info["sysManufacturer"] = next[8:10]
    if len(str) == 14:
        new_info["crc"] = next[10:13]
    str = str[10:]
    print(new_info)
print(f"CRC: {crc}")
print(f"BinID: {binId}")