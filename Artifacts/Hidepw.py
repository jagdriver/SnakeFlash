import base64
import sys
base64_encoded_data = base64.b64encode(bytes(sys.argv[1], 'utf-8'))
base64_message = base64_encoded_data.decode('utf-8')
print(base64_message)
