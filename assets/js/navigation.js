// script.js
document.addEventListener('DOMContentLoaded', function() {
    const mobileToggle = document.getElementById('mobileToggle');
    const navItems = document.getElementById('navItems');
    const navItemsList = document.querySelectorAll('.nav-item');
    
    // Toggle mobile menu
    mobileToggle.addEventListener('click', function() {
        navItems.classList.toggle('active');
        this.querySelector('i').classList.toggle('fa-bars');
        this.querySelector('i').classList.toggle('fa-times');
    });
    
    // Handle dropdowns on mobile
    navItemsList.forEach(item => {
        const dropdown = item.querySelector('.dropdown');
        const link = item.querySelector('a');
        
        if (dropdown) {
            link.addEventListener('click', function(e) {
                // On mobile, prevent default and toggle dropdown
                if (window.innerWidth <= 992) {
                    e.preventDefault();
                    dropdown.classList.toggle('active');
                }
            });
        }
    });
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 992 && navItems.classList.contains('active') && 
            !e.target.closest('.navbar') && !e.target.closest('#navItems')) {
            navItems.classList.remove('active');
            mobileToggle.querySelector('i').classList.add('fa-bars');
            mobileToggle.querySelector('i').classList.remove('fa-times');
            
            // Also close any open dropdowns
            document.querySelectorAll('.dropdown').forEach(dd => {
                dd.classList.remove('active');
            });
        }
    });
});

