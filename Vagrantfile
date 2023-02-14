Vagrant.configure("2") do |config|
    config.vm.box = "./artifacts/qemu/jammy.box"

    config.nfs.verify_installed = false
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'

    config.vm.provider :libvirt do |libvirt|
      libvirt.storage_pool_name = "pool"
      libvirt.memory = 8192
      libvirt.cpus = 4
      libvirt.storage :file, :size => '128M'
      libvirt.storage :file, :size => '128M'
      libvirt.video_type = "virtio"
    end
  
    N = 1
    (1..N).each do |machine_id|
      config.vm.define "stm32-env-#{machine_id}" do |machine|
        machine.vm.hostname = "stm32-env-#{machine_id}"
        
        # if machine_id == N
        #   machine.vm.provision :ansible do |ansible|
        #     ansible.limit = "all"
        #     ansible.playbook = "../provision_proxmox.yaml"
        #     ansible.verbose = true
        #   end
        # end

      end
    end
  end