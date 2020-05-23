from weblogic.security.internal import *
from weblogic.security.internal.encryption import *
encryptionService = SerializedSystemIni.getEncryptionService(".")
clearOrEncryptService = ClearOrEncryptedService(encryptionService)

# Take encrypt password from user
pwd = raw_input("Paste encrypted password ({AES}fk9EK...): ")

# Delete unnecessary escape characters
preppwd = pwd.replace("\\", "")

# Display password
print "Decrypted string is: " + clearOrEncryptService.decrypt(preppwd)
