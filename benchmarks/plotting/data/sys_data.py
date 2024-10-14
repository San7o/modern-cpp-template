class sys_data:
    """
    This class contains the system data that is used to calculate the
    theoretical peak bandwidth of the system.
    """

    megabyte = 1024 * 1024
    # sudo dmidecode --type 17 | grep "Memory Speed"
    memory_clock_rate = 3200 * megabyte  # bT/s
    # sudo lshw -C display | grep width
    bus_width = 8  # 64-bit
    transfer_rate = 2  # since is DDR

    peak_theoretical_bandwidth = \
        memory_clock_rate * bus_width * transfer_rate / 10e9  # b/s
