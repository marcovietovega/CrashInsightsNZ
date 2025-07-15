# CrashInsightsNZ 🚗📊

A comprehensive R Shiny dashboard for analyzing and visualizing traffic crash data in New Zealand. This interactive web application provides insights into traffic accidents, regional comparisons, and detailed data exploration capabilities.

## 🌟 Features

- **Interactive Dashboard**: User-friendly interface built with Shiny Dashboard
- **Regional Comparisons**: Compare crash statistics across different New Zealand regions
- **Interactive Maps**: Visualize crash data geographically using interactive maps
- **Data Download**: Export filtered datasets for further analysis
- **Comprehensive Analytics**: Detailed statistics and visualizations of crash patterns

## 🛠️ Technology Stack

- **R**: Core programming language
- **Shiny**: Web application framework
- **Shiny Dashboard**: Enhanced UI components
- **Plotly**: Interactive visualizations
- **SQLite**: Database for storing crash data
- **Git LFS**: Large file storage for the database

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

## 🚀 Getting Started

### Prerequisites

Make sure you have R installed on your system. You'll also need the following R packages:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "plotly",
  "DBI",
  "RSQLite",
  "dplyr",
  "ggplot2"
))
```

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/mv03790/CrashInsightsNZ.git
   cd CrashInsightsNZ
   ```

2. **Install Git LFS** (if not already installed):

   ```bash
   git lfs install
   ```

3. **Pull the database file**:

   ```bash
   git lfs pull
   ```

4. **Run the application**:
   ```r
   # In R or RStudio
   shiny::runApp()
   ```

### Running the Application

1. **Local Development**:

   - Open `server.R` or `ui.R` in RStudio
   - Click "Run App" button, or
   - Use `shiny::runApp()` in the R console

2. **Accessing the Dashboard**:
   - The application will open in your default web browser
   - Navigate through different tabs using the sidebar menu

## 📊 Dashboard Features

### Home Tab

- Overview of crash statistics
- Key performance indicators
- Summary visualizations

### Compare Regions Tab

- Side-by-side regional comparisons
- Interactive charts and graphs
- Statistical analysis tools

### Map Tab

- Interactive geographical visualization
- Location-based crash data
- Customizable map layers

### Download Tab

- Export filtered datasets
- Multiple format options
- Data customization tools

## 🗃️ Database Information

The project uses a SQLite database (`crash_data.sqlite`) stored with Git LFS due to its size. The database contains:

- Traffic crash records for New Zealand
- Location information
- Temporal data (dates, times)
- Crash severity and type classifications
- Vehicle and casualty information

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 Data Sources

This project analyzes traffic crash data from the **NZ Transport Agency Open Data platform**. The data provides comprehensive information about traffic crashes across New Zealand.

**Data Attribution:**

- **Source**: NZ Transport Agency (Waka Kotahi)
- **Platform**: Open Data platform
- **Data Type**: Traffic crash records and statistics

Please ensure proper attribution and compliance with data usage policies when using this application.

## ⚠️ Important Notes

- **Large Files**: The SQLite database is managed with Git LFS
- **Dependencies**: Ensure all required R packages are installed
- **Data Privacy**: Be mindful of sensitive information in crash data
- **Performance**: Large datasets may require additional memory and processing time

## 📄 License

This project is developed as part of the DATA472 course at Victoria University of Wellington.

## 👨‍💻 Author

**Marco Vieto** (mv03790)  
Master of Data Science - Victoria University of Wellington  
DATA472 Final Project - 2024 Trimester 1

## 🔄 Version History

- **v1.0**: Initial release with core dashboard functionality
- Features: Interactive maps, regional comparisons, data download capabilities

---

**📊 Explore New Zealand's traffic data with CrashInsightsNZ - Making roads safer through data-driven insights! 🚗✨**
