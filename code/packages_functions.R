
# -----
# Preliminary
# -----

# Load Packages
packageSetting <- function() {
  # Required packages
  requiredPackages <- c("data.table", "dplyr", "tidyverse", "jtools",
                        "clubSandwich", "fANCOVA", "estimatr", 
                        "metafor", "binsreg",
                        "ggplot2", "ggExtra", "cowplot",
                        "readstata13", "magick")
  
  # Load packages (install first if not exist in the system) 
  for(p in requiredPackages){
    if(!require(p, character.only = TRUE)) install.packages(p, dependencies = TRUE)
    library(p, character.only = TRUE)
  }
}


# Define new color palette
my.palette        <- c("#77AADD", "#99DDFF", "#44BB99", "#BBCC33", "#AAAA00", "#EEDD88", "#EE8866", "#FFAABB", "#DDDDDD")
my.hc.palette     <- c("#DDAA33", "#BB5566", "#004488")
my.bright.palette <- c("#4477AA", "#66CCEE", "#228833", "#CCBB44", "#EE6677", "#AA3377", "#BBBBBB")
my.dark.palette   <- c("#222255", "#225555", "#225522", "#666633", "#663333", "#555555")


# Font size for visualization
font.size <- c(12)


# -----
# Functions
# ----- 

plot.quant <- function(data) {
  p <- ggplot(data, aes(x = log.eq.q, y = log.quantity)) +
    geom_abline(slope = 1, linetype = "dashed") +
    geom_smooth(method = "lm", se = FALSE, colour = my.bright.palette[3]) +
    geom_hex(bins = 50) +
    # geom_jitter(alpha = 0.02, width = 0.05) +
    xlab("Log(equilibrium trades)") +
    ylab("Log(observed trades)") +
    scale_x_continuous(limits = c(-0.05, 6.0)) +
    scale_y_continuous(limits = c(-0.05, 6.0)) +
    scale_fill_distiller(palette = "Spectral", name = c("# obs.")) +
    theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
    theme(text = element_text(size = font.size, family = "Helvetica"))
  return(p)
}

plot.theory.comp <- function(data, dim, type, theory, avg, zi) {
  if (dim == 1) {
    x  <- c("trx_order_buyer")
    y  <- c("trx_order_seller")
  } else if (dim == 2) {
    x  <- c("auto_corr")
    y  <- c("trx_order_seller")
    an <- c(0, 1, 1, 1)
    ma <- c(0, 1)
  } else if (dim == 3) {
    x  <- c("trx_order_buyer")
    y  <- c("auto_corr")
    an <- c(-1, -1, 0, 1)
    ma <- c(-1, 0)
  }
  
  # Base plot
  if (type == "density") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = 0.8, show.legend = FALSE) +
      scale_fill_distiller(palette = 4, direction = 1, guide = "none") +
      xlab(expression(rho[buyer])) +
      ylab(expression(rho[seller])) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  } else if (type == "point") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_point(alpha = 0.2) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  }
  
  # Add average
  if (avg == TRUE) {
    avg.data <- data.frame(mean.x = mean(data[, x]), mean.y = mean(data[, y]))
    p <- p + 
      geom_point(data = avg.data, aes(x = mean.x, y = mean.y), shape = 23, colour = "red", fill = "red", size = 2, show.legend = FALSE)
  }
  
  # Overlay theory predicsions
  if (theory == TRUE & dim == 1) {
    p <- p + 
      geom_point(aes(x = -1, y = 1, colour = "AN"), shape = 0, size = 4, stroke = 1) +
      geom_point(aes(x = -1, y = 1, colour = "MA"), size = 2) +
      stat_ellipse(data = zi, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI" = my.bright.palette[5], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]), labels = c("Against nature", "Mutual adjustment", "Zero intelligence")) 
  } else if (theory == TRUE & dim > 1) {
    p <- p + 
      geom_segment(aes(x = an[1], xend = an[2], y = an[3], yend = an[4], colour = "AN"), size = 1) +
      geom_point(aes(x = ma[1], y = ma[2], colour = "MA"), size = 2) +
      stat_ellipse(data = zi, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI" = my.bright.palette[5], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]), labels = c("Against nature", "Mutual adjustment", "Zero intelligence")) 
  }
  
  # Axis labels
  if (dim == 1) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[seller])) 
  } else if (dim == 2) {
    p <- p + xlab(expression(rho[price])) + ylab(expression(rho[seller]))
  } else if (dim == 3) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[price]))
  }
  # Output
  return(p)
}



plot.theory.comp.mult <- function(data, dim, type, theory, avg, zi1, zi2, zi3, zi4, zi5) {
  if (dim == 1) {
    x  <- c("trx_order_buyer")
    y  <- c("trx_order_seller")
  } else if (dim == 2) {
    x  <- c("auto_corr")
    y  <- c("trx_order_seller")
    an <- c(0, 1, 1, 1)
    ma <- c(0, 1)
  } else if (dim == 3) {
    x  <- c("trx_order_buyer")
    y  <- c("auto_corr")
    an <- c(-1, -1, 0, 1)
    ma <- c(-1, 0)
  }
  
  # Base plot
  if (type == "density") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = 0.8, show.legend = FALSE) +
      scale_fill_distiller(palette = 4, direction = 1, guide = "none") +
      xlab(expression(rho[buyer])) +
      ylab(expression(rho[seller])) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  } else if (type == "point") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_point(alpha = 0.2) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  }
  
  # Add average
  if (avg == TRUE) {
    avg.data <- data.frame(mean.x = mean(data[, x]), mean.y = mean(data[, y]))
    p <- p + 
      geom_point(data = avg.data, aes(x = mean.x, y = mean.y), shape = 23, colour = "red", fill = "red", size = 2, show.legend = FALSE)
  }
  
  # Overlay theory predicsions
  if (theory == TRUE & dim == 1) {
    p <- p + 
      geom_point(aes(x = -1, y = 1, colour = "MA"), size = 2) +
      geom_point(aes(x = -1, y = 1, colour = "AN"), shape = 0, size = 4, stroke = 1) +
      stat_ellipse(data = zi1, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI1"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi2, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI2"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi3, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI3"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi4, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI4"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi5, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI5"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI5" = my.bright.palette[1], "ZI4" = my.bright.palette[2], "ZI3" = my.bright.palette[7], "ZI2" = my.bright.palette[6], "ZI1" = my.bright.palette[5], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]),
                          labels = c("Against nature", "Mutual adjustment", "Zero intelligence 1", "Zero intelligence 2", "Zero intelligence 3", "Zero intelligence 4", "Zero intelligence 5")) 
  } else if (theory == TRUE & dim > 1) {
    p <- p + 
      geom_segment(aes(x = an[1], xend = an[2], y = an[3], yend = an[4], colour = "AN"), size = 1) +
      geom_point(aes(x = ma[1], y = ma[2], colour = "MA"), size = 2) +
      stat_ellipse(data = zi1, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI1"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi2, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI2"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi3, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI3"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi4, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI4"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi5, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI5"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI5" = my.bright.palette[1], "ZI4" = my.bright.palette[2], "ZI3" = my.bright.palette[7], "ZI2" = my.bright.palette[6], "ZI1" = my.bright.palette[5], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]),
                          labels = c("Against nature", "Mutual adjustment", "Zero intelligence 1", "Zero intelligence 2", "Zero intelligence 3", "Zero intelligence 4", "Zero intelligence 5"))
  }
  
  # Axis labels
  if (dim == 1) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[seller])) 
  } else if (dim == 2) {
    p <- p + xlab(expression(rho[price])) + ylab(expression(rho[seller]))
  } else if (dim == 3) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[price]))
  }
  # Output
  return(p)
}

plot.theory.comp.group1 <- function(data, dim, type, theory, avg, zi1, zi2, zi4) {
  if (dim == 1) {
    x  <- c("trx_order_buyer")
    y  <- c("trx_order_seller")
  } else if (dim == 2) {
    x  <- c("auto_corr")
    y  <- c("trx_order_seller")
    an <- c(0, 1, 1, 1)
    ma <- c(0, 1)
  } else if (dim == 3) {
    x  <- c("trx_order_buyer")
    y  <- c("auto_corr")
    an <- c(-1, -1, 0, 1)
    ma <- c(-1, 0)
  }
  
  # Base plot
  if (type == "density") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = 0.8, show.legend = FALSE) +
      scale_fill_distiller(palette = 4, direction = 1, guide = "none") +
      xlab(expression(rho[buyer])) +
      ylab(expression(rho[seller])) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  } else if (type == "point") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_point(aes(shape = market), alpha = 0.4) +
      scale_shape_manual(values=c(17, 23, 3)) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  }
  
  # Add average
  if (avg == TRUE) {
    avg.data <- data.frame(mean.x = mean(data[, x]), mean.y = mean(data[, y]))
    p <- p + 
      geom_point(data = avg.data, aes(x = mean.x, y = mean.y), shape = 23, colour = "red", fill = "red", size = 2, show.legend = FALSE)
  }
  
  # Overlay theory predicsions
  if (theory == TRUE & dim == 1) {
    p <- p + 
      geom_point(aes(x = -1, y = 1, colour = "AN"), shape = 0, size = 4, stroke = 1) +
      geom_point(aes(x = -1, y = 1, colour = "MA"), size = 2) +
      stat_ellipse(data = zi1, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI1"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi2, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI2"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi4, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI4"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI4" = my.bright.palette[2], "ZI2" = my.bright.palette[6], "ZI1" = my.bright.palette[5], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]),
                          labels = c("Against nature", "Mutual adjustment", "Zero intelligence 1", "Zero intelligence 2", "Zero intelligence 4")) 
  } else if (theory == TRUE & dim > 1) {
    p <- p + 
      geom_segment(aes(x = an[1], xend = an[2], y = an[3], yend = an[4], colour = "AN"), size = 1) +
      geom_point(aes(x = ma[1], y = ma[2], colour = "MA"), size = 2) +
      stat_ellipse(data = zi1, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI1"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi2, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI2"), level = 0.95, alpha = 0.8, size = 1) +
      stat_ellipse(data = zi4, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI4"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("AN" = my.bright.palette[3], "MA" = my.bright.palette[4], "ZI1" = my.bright.palette[5], "ZI2" = my.bright.palette[6], "ZI4" = my.bright.palette[2]),
                          labels = c("Against nature", "Mutual adjustment", "Zero intelligence 1", "Zero intelligence 2", "Zero intelligence 4"))
  }
  
  # Axis labels
  if (dim == 1) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[seller])) 
  } else if (dim == 2) {
    p <- p + xlab(expression(rho[price])) + ylab(expression(rho[seller]))
  } else if (dim == 3) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[price]))
  }
  # Output
  return(p)
}

plot.theory.group2 <- function(data, dim, type, theory, avg, zi) {
  if (dim == 1) {
    x  <- c("trx_order_buyer")
    y  <- c("trx_order_seller")
  } else if (dim == 2) {
    x  <- c("auto_corr")
    y  <- c("trx_order_seller")
    an <- c(0, 1, 1, 1)
    ma <- c(0, 1)
  } else if (dim == 3) {
    x  <- c("trx_order_buyer")
    y  <- c("auto_corr")
    an <- c(-1, -1, 0, 1)
    ma <- c(-1, 0)
  }
  
  # Base plot
  if (type == "density") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = 0.8, show.legend = FALSE) +
      scale_fill_distiller(palette = 4, direction = 1, guide = "none") +
      xlab(expression(rho[buyer])) +
      ylab(expression(rho[seller])) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  } else if (type == "point") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_point(alpha = 0.2) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  }
  
  # Add average
  if (avg == TRUE) {
    avg.data <- data.frame(mean.x = mean(data[, x]), mean.y = mean(data[, y]))
    p <- p + 
      geom_point(data = avg.data, aes(x = mean.x, y = mean.y), shape = 23, colour = "red", fill = "red", size = 2, show.legend = FALSE)
  }
  
  # Overlay theory predicsions
  if (theory == TRUE & dim == 1) {
    p <- p + 
      geom_point(aes(x = -1, y = 1, colour = "AN"), shape = 0, size = 4, stroke = 1) +
      geom_point(aes(x = -1, y = 1, colour = "MA"), size = 2) +
      stat_ellipse(data = zi, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI" = my.bright.palette[7], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]), labels = c("Against nature", "Mutual adjustment", "Zero intelligence 3")) 
  } else if (theory == TRUE & dim > 1) {
    p <- p + 
      geom_segment(aes(x = an[1], xend = an[2], y = an[3], yend = an[4], colour = "AN"), size = 1) +
      geom_point(aes(x = ma[1], y = ma[2], colour = "MA"), size = 2) +
      stat_ellipse(data = zi, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI" = my.bright.palette[7], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]), labels = c("Against nature", "Mutual adjustment", "Zero intelligence 3")) 
  }
  
  # Axis labels
  if (dim == 1) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[seller])) 
  } else if (dim == 2) {
    p <- p + xlab(expression(rho[price])) + ylab(expression(rho[seller]))
  } else if (dim == 3) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[price]))
  }
  # Output
  return(p)
}

plot.theory.group3 <- function(data, dim, type, theory, avg, zi) {
  if (dim == 1) {
    x  <- c("trx_order_buyer")
    y  <- c("trx_order_seller")
  } else if (dim == 2) {
    x  <- c("auto_corr")
    y  <- c("trx_order_seller")
    an <- c(0, 1, 1, 1)
    ma <- c(0, 1)
  } else if (dim == 3) {
    x  <- c("trx_order_buyer")
    y  <- c("auto_corr")
    an <- c(-1, -1, 0, 1)
    ma <- c(-1, 0)
  }
  
  # Base plot
  if (type == "density") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = 0.8, show.legend = FALSE) +
      scale_fill_distiller(palette = 4, direction = 1, guide = "none") +
      xlab(expression(rho[buyer])) +
      ylab(expression(rho[seller])) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  } else if (type == "point") {
    p <- ggplot(data, aes(x = !!ensym(x), y = !!ensym(y))) +
      geom_vline(xintercept = 0, linetype = "dashed") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      geom_point(alpha = 0.2) +
      scale_x_continuous(expand = c(0, 0), limits = c(-1.15, 1.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c(-1.05, 1.15)) +
      theme(legend.title = element_blank()) +
      theme(text = element_text(size = font.size, family = "Helvetica"))
  }
  
  # Add average
  if (avg == TRUE) {
    avg.data <- data.frame(mean.x = mean(data[, x]), mean.y = mean(data[, y]))
    p <- p + 
      geom_point(data = avg.data, aes(x = mean.x, y = mean.y), shape = 23, colour = "red", fill = "red", size = 2, show.legend = FALSE)
  }
  
  # Overlay theory predicsions
  if (theory == TRUE & dim == 1) {
    p <- p + 
      geom_point(aes(x = -1, y = 1, colour = "AN"), shape = 0, size = 4, stroke = 1) +
      geom_point(aes(x = -1, y = 1, colour = "MA"), size = 2) +
      stat_ellipse(data = zi, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI" = my.bright.palette[1], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]), labels = c("Against nature", "Mutual adjustment", "Zero intelligence 5")) 
  } else if (theory == TRUE & dim > 1) {
    p <- p + 
      geom_segment(aes(x = an[1], xend = an[2], y = an[3], yend = an[4], colour = "AN"), size = 1) +
      geom_point(aes(x = ma[1], y = ma[2], colour = "MA"), size = 2) +
      stat_ellipse(data = zi, aes(x = !!ensym(x), y = !!ensym(y), colour = "ZI"), level = 0.95, alpha = 0.8, size = 1) +
      scale_colour_manual(values = c("ZI" = my.bright.palette[1], "MA" = my.bright.palette[4], "AN" = my.bright.palette[3]), labels = c("Against nature", "Mutual adjustment", "Zero intelligence 5")) 
  }
  
  # Axis labels
  if (dim == 1) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[seller])) 
  } else if (dim == 2) {
    p <- p + xlab(expression(rho[price])) + ylab(expression(rho[seller]))
  } else if (dim == 3) {
    p <- p + xlab(expression(rho[buyer])) + ylab(expression(rho[price]))
  }
  # Output
  return(p)
}

# Compute Supply-Demand Curves
sd.curve <- function(v.buyer, v.seller) {
  v <- unique(c(v.buyer, v.seller))
  
  # Supply-demand functions
  if (max(v)-min(v) > 10000) {
    step <- 10
  } else if (max(v)-min(v) > 1000 & max(v)-min(v) <= 10000) {
    step <- 1
  } else {
    step <- 0.1
  }
  price         <- seq(min(v), max(v), step)
  supply        <- rep(0, length(price))
  demand        <- rep(0, length(price))
  supply.demand <- data.frame(price, supply, demand)
  
  for (i in 1:length(price)) {
    supply.demand$supply[i] <- sum(v.seller<=price[i])
    supply.demand$demand[i] <- sum(v.buyer>=price[i])
  }
  
  supply.demand[supply.demand$price>max(v.seller), c("supply")] <- NA
  supply.demand[supply.demand$price<min(v.buyer), c("demand")]  <- NA
  
  return(supply.demand)
}


# Compute Competitive Equilibrium Price and Quantity from Supply-Demand Curves
eqm <- function(supply.demand) {
  # Identify the crossing point
  if (any(supply.demand$supply>=supply.demand$demand) == TRUE) {
    cross.point <- which(supply.demand$supply==supply.demand$demand)
    if (length(cross.point) > 0) {
      eq.price    <- (supply.demand$price[min(cross.point)-1] + supply.demand$price[max(cross.point)]) / 2
      eq.quantity <- min(supply.demand[cross.point,2], supply.demand[cross.point-1,3])
      
      # Return equilibrium price and quantity
      eq <- list(eq.price, eq.quantity)
    } else {
      eq <- list(NA, NA)
    }
  } else if (tail(supply.demand$supply<supply.demand$demand, 1) == TRUE) {
    eq.price    <- tail(supply.demand, 1)[1]
    eq.quantity <- tail(supply.demand, 1)[2]
    
    # Return equilibrium price and quantity
    eq <- list(eq.price, eq.quantity)
  } else {
    eq <- list(NA, NA)
  }
  
  return(eq)
}


# Plot Supply-Demand Functions and Equilibrium
plot.sd <- function(sd, eq) {
  plot <- ggplot(data = sd, aes(x = price)) + 
    geom_vline(aes(xintercept = eq[1]), colour = "black", linetype = "dashed", alpha = 0.8) + 
    geom_hline(aes(yintercept = eq[2]), colour = "black", linetype = "dashed", alpha = 0.8) + 
    geom_step(aes(y = supply), colour = "grey50", size = 1.2) +
    geom_step(aes(y = demand), colour = "grey5", size = 1.2) +
    scale_y_continuous(breaks = seq(1, 15, 2)) +
    xlim(c(0, 200)) +
    xlab("Price") +
    ylab("Quantity") +
    ggtitle("Market configuration") +
    coord_flip() +
    theme(plot.title = element_text(face = "plain")) +
    theme(text = element_text(size = 16, family = "Helvetica"))
  return(plot)  
}

