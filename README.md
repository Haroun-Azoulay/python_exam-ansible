# <p align="center">Exam ansible </p>

## 📖 Context
It’s a custom Python module developed to simulate a minimal version of Ansible, aimed at helping students understand how infrastructure-as-code tools work.
The goal is to let them practice Python programming while grasping core Ansible concepts like task execution, modules, and remote actions — without needing the full complexity of the actual Ansible engine.


## 📜 Subject
The script automates a set of remote checks and corrections by connecting via SSH to the student’s VM using sshpass. Each menu item corresponds to a common Ansible task or expected configuration in the student's machine.

🗝 Key Features of the Script:

- Remote connection: The script connects via SSH to a specific VM using user-defined credentials.

- Interactive menu: The user can select from several tests (e.g., checking installed packages, system parameters, running services).

- Automated remediation: If the script detects a valid condition (e.g., nginx is installed or a file exists), it proceeds to delete or modify the resource, mimicking what an Ansible task would do.

## 📸 Screens

![Cover](https://github.com/Haroun-Azoulay/python_exam-ansible/blob/main/img/ansible-dashboard.png)

        
## 🛠 Tech Stack
- [Bash](https://www.gnu.org/software/bash/manual/bash.html)

        
## 🙇 Acknowledgements      
- A [H3 Hitema](https://www.h3hitema.fr/) - thanks also for being a teacher on the ansible master module.

        
        
## ❤ Support  
A simple star to this project repo is enough to keep me motivated on this project for days. If you find your self very much excited with this project let me know with a tweet.

If you have any questions, feel free to reach out to me on.
        
## 🙇 Author
#### Haroun Azoulay

- Github: [@Haroun-Azoulay](https://github.com/Haroun-Azoulay)


