# Ruby Casptone Project - Build a CSS Linter

This project was done as the final/casptone prject of the Microverse's Ruby curriculum. The goal of the project is to build CSS linter.

It tests the understanding of ruby;OOP, Classes, inheritance, encapsulation, testing and project structure organization

Linters are tools that prevent mistakes as we write our programs.

In this case, the linter built is to:
- Catch errors
- Enforce code style conventions
- Enforce best practices

## Built with

- Ruby
- RSpec for testing
- Colorize

## Getting Started
To have a local version of this code running do the following:
- Clone the repository `git clone https://github.com/kimothokamau/linter-ruby-casptone.git`
- Install the ruby compiler and any preferred code editor of your choice
- Navigate to the directory containing this code
- Run the command `ruby bin/main.rb`

## Good code
~~~ruby

    .ticket-wrapper {
    display: grid;
    grid-template-rows: 1fr 9fr 1fr;
    grid-template-columns: 1fr 6fr 1fr;
    } 

    #lunch-wrapper {
    display: grid;
    grid-template-rows: 1fr 1fr 1fr 1fr;
    grid-template-columns: 1fr 6fr 1fr;
    }

    .btn:hover {
    opacity: 0.7;
    }       

    #slct-lunch {
    grid-area: slct-lunch;
    align-self: center;
    justify-content: center;
    }

    .vegetarians {color: red }  

    #text-bg { background-color: rebeccapurple }
~~~

## Bad code
~~~ruby

  . ticket-wrapper {
    display: grid;
  } 

  # lunch-wrapper {
    display: grid;
  }

  .btn:hover{
    opacity: 0.7;
  }       

  #slct-lunch{
    grid-area: slct-lunch;
    align-self: center;
    justify-content: center;
  }

  .vegetarians { }  

  #text-bg { }  
~~~

## Authors

**Kimotho Kamau**

- GitHub: [@kimothokamau](https://github.com/kimothokamau)
- LinkedIn: [LinkedIn](https://www.linkedin.com/in/kimotho-kamau-6ab307185/)

## Contributing

Contributions, issues, and feature requests are welcome!

## Show your support

Give a ⭐️ if you like this project!

## License

This project is [MIT](./LICENSE) licensed.