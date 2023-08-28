# Hexagonify raster
# This function takes a raster layer and divides it into hexagonal cells based on a given set of polygons. 
# For each hexagonal cell, the function calculates the mean value of the raster layer within the boundaries 
# of the cell using the specified fun function. 
# The output is a vector of the calculated mean values for each hexagonal cell.

hexagonify <- function(raster, polygons, fun){
  # Convert raster to points
  points <- rasterToPoints(raster, spatial = TRUE) %>% 
    st_as_sf()
  
  # Checks which points intersect with which hexagon (polygons)
  poly_point_intersect <- st_intersects(polygons, points)
  
  # A function that is applied to every point per polygon, it returns the mean of all point values in the polygons 
  hexagon_value <- sapply(poly_point_intersect, function(ids) {
    pts <- points [ids, ]
    return(fun(pts[[1]])) # Accesses the value in the first column
  })
  
  # Fills in the average walking time per hexagon cell 
  return(hexagon_value)
}

# --------
# Hexagonify points
hexagonify_points <- function(points, polygons, fun){
  
  # Checks which points intersect with which hexagon (polygons)
  poly_point_intersect <- st_intersects(polygons, points)
  
  # A function that is applied to every point per polygon, it returns the mean of all point values in the polygons 
  hexagon_value <- sapply(poly_point_intersect, function(ids) {
    pts <- points [ids, ]
    return(fun(pts[[363]])) # Accesses the value in the first column
  })
  
  # Fills in the average walking time per hexagon cell 
  return(hexagon_value)
}
