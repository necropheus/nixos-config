{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "necropolis";
        "server role" = "standalone server";

        # Only allow connections from local network
        "hosts allow" = "192.168. 10. 172.16. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";

        # Disable printer sharing
        "load printers" = "no";
        "printing" = "bsd";
        "printcap name" = "/dev/null";
        "disable spoolss" = "yes";
      };

      home = {
        path = "/home/necropheus";
        browseable = "yes";
        "read only" = "no";
        "valid users" = "necropheus";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # Enable mDNS/Avahi so the share is auto-discoverable
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
