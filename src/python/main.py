from pynvml import *
import pprint
import json

def nvdia_initialize():
    nvmlInit()

def get_driver_version():
    return nvmlSystemGetDriverVersion()

def get_gpu_count():
    return nvmlDeviceGetCount()

def bytes_to_gb(bytes):
    print("bytes: ", bytes)
    if bytes == None:
        return 0
    return round(bytes / (1024 ** 3),2)

# Check if this file was called from the command line
from pynvml import *

def get_gpu_names():
    # Implement the logic to get the GPU names
    gpu_names = []
    for i in range(nvmlDeviceGetCount()):
        handle = nvmlDeviceGetHandleByIndex(i)
        gpu_names.append(nvmlDeviceGetName(handle))
    return gpu_names

def get_memory_info(handle):
    # Implement the logic to get the memory info
    memory_info = nvmlDeviceGetMemoryInfo(handle)

    return memory_info

def memory_info_to_dict(memory_info):
    return {attr: getattr(memory_info, attr) for attr in dir(memory_info) if not attr.startswith('__') and not callable(getattr(memory_info, attr))}

# def object_to_json(obj):
#     if isinstance(obj, c_nvmlMemory_t):
#         return json.dumps(memory_info_to_dict(obj))
#     return json.dumps(obj)

# class PyCSimpleTypeEncoder(json.JSONEncoder):
#     def default(self, obj):
#         if isinstance(obj, PyCSimpleType):
#             # Convert obj into a JSON-serializable format
#             return str(obj)
#         return super().default(obj)

if __name__ == "__main__":
    # Import the main function from the main module
    from main import main
    # Call the main function
    main()

def main():

    # Initialize the NVML library
    nvmlInit()

    # Print a welcome message
    print("Welcome to the unfinished nvidia stats program!")
    print(f"Driver version: {get_driver_version()}")
    print(f"GPU count: {get_gpu_count()}")
    print(f"GPUs found: {get_gpu_names()}")
    memory_info = get_memory_info(nvmlDeviceGetHandleByIndex(0))
    print(f"Memory info: {memory_info_to_dict(memory_info)}")
    print (f"Memory total: {bytes_to_gb(memory_info.total)} GB")
    print (f"Memory free: {bytes_to_gb(memory_info.free)} GB")
    print (f"Memory used: {bytes_to_gb(memory_info.used)} GB")
    nvmlShutdown()
    print("Goodbye!")

