# Cashier Shop

This Elixir application implements a checkout process, allowing you to manage and compute transactions using various rules and products.

## Getting Started

### Install Elixir

Follow the installation guide provided at [Elixir Installation Guide](https://elixir-lang.org/install.html).

### Clone the Project

Clone this repository to your local machine using:

```bash
git clone https://github.com/ifebrand6/cashier-app-kantox


```
### Install Dependencies

```bash
    cd cashier-app-kantox
    mix deps.get
```

### Rub test

```bash
    mix test
```

### Usage
```

# Create new product instances
test1 = Shop.Product.new("GR1", "Green Tea", 5_00)
test2 = Shop.Product.new("GR2", "Green Tea", 5_00)

# Add rules to the checkout process
Shop.add_rule(Shop.Rules.CEO)

# Start the scanning process
Shop.scan()

# Scan individual products
Shop.scan(test1)

# Get the total amount
Shop.total()  # Output: "5_00£"

```

### Design Considerations

Money Type Instead of Float: Using the Money type is preferred over float for monetary values. Floats can introduce precision issues, while the Money type ensures accurate calculations and avoids rounding errors.

RuleBehavior: Implementing rules via RuleBehavior allows for easy and flexible extension of checkout rules. You can add or modify rules without changing the core checkout logic.

Agent Instead of GenServer: An Agent is used for state management due to its simplicity compared to GenServer. This choice makes the code easier to maintain and understand.

Credo: Credo is used to ensure code quality by analyzing code for style, consistency, and complexity. Running mix credo --strict helps maintain high standards of code quality.

Format: Automatic code formatting with mix format helps maintain a consistent code style across the project, improving readability and maintainability.

Dialyzer: Dialyzer is used to perform static analysis on the code, detecting type discrepancies and potential errors. This tool helps catch bugs and improve the overall reliability of the codebase.


