defmodule Servy.VideoCam do
  @doc """
  Simulates sending a request to an external API
  to get a snapshot image from a video camera
  """
  def get_snapshot(camera_name) do
    # Code goes here to send a request to the external api
    
    # Sleep for 1 second to simulate that the API can be slow
    :timer.sleep(1000)

    # Example response returned from the API:
    "#{camera_name}-snapshot-#{:rand.uniform(1000)}.jpg"
  end
end

# Servy.VideoCam.get_snapshot("cam-1")
# Servy.VideoCam.get_snapshot("cam-2")
# Servy.VideoCam.get_snapshot("cam-3")
