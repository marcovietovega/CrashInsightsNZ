# CrashInsightsNZ 🚗📊

A user-friendly R Shiny dashboard for exploring and understanding traffic crash data in New Zealand. This web app helps you learn about traffic accidents, compare regions, and dive into detailed data.

**Live Dashboard**: [CrashInsightsNZ](https://marcovietovega.shinyapps.io/crashinsightsnz/)

## 🌟 Features

- **Interactive Dashboard**: Easy-to-use interface built with Shiny Dashboard
- **Regional Comparisons**: Compare crash statistics across New Zealand regions
- **Interactive Maps**: See crash data on maps you can interact with
- **Data Download**: Save filtered datasets for your own analysis
- **Detailed Analytics**: View crash patterns with charts and statistics

## 🛠️ Technology Stack

- **R**: Programming language used
- **Shiny**: Framework for web apps
- **Shiny Dashboard**: Tools for better UI
- **Plotly**: Interactive charts
- **SQLite**: Database for crash data

## 📁 Project Structure

```
CrashInsightsNZ/
├── server.R              # Main server logic
├── ui.R                  # Main UI definition
├── ui.html              # Additional HTML components
├── Preprocessing.R       # Data preprocessing scripts
├── crash_data.sqlite    # SQLite database (stored with Git LFS)
├── tabs/                # Modular UI and server components
│   ├── home_server.R    # Home tab server logic
│   ├── home_ui.R        # Home tab UI
│   ├── map_server.R     # Map tab server logic
│   ├── map_ui.R         # Map tab UI
│   ├── compare_server.R # Compare tab server logic
│   ├── compare_ui.R     # Compare tab UI
│   ├── download_server.R# Download tab server logic
│   └── download_ui.R    # Download tab UI
├── www/                 # Web assets
│   └── custom.css       # Custom styling
└── rsconnect/           # Deployment configuration
```

## 📊 Dashboard Features

### Home Tab

- Overview of crash statistics
- Key performance indicators
- Summary charts

### Compare Regions Tab

- Compare crash data for different regions
- Interactive charts
- Statistical tools

### Map Tab

- See crash data on maps
- Location-based crash details
- Customizable map layers

### Download Tab

- Save filtered datasets
- Choose from different formats
- Customize the data you save

## 📝 Data Sources

This project uses traffic crash data from the **NZ Transport Agency Open Data platform**. The data includes records of traffic crashes across New Zealand up to 2022.

**Data Attribution:**

- **Source**: NZ Transport Agency (Waka Kotahi)
- **Platform**: Open Data platform
- **Data Type**: Traffic crash records and statistics

Please make sure to follow data usage rules when using this application.

## 📄 License

This project is part of the DATA472 course at Victoria University of Wellington.

## 👨‍💻 Author

**Marco Vieto Vega** (marcovietovega)  
Master of Data Science - Victoria University of Wellington  
DATA472 Final Project - 2024 Trimester 1

## 🔄 Version History

- **v1.0**: First release with main dashboard features
- Features: Interactive maps, regional comparisons, data download tools

---

**📊 Explore New Zealand's traffic data with CrashInsightsNZ - Making roads safer through data-driven insights! 🚗✨**
