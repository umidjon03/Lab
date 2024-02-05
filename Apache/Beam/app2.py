import apache_beam as beam
from apache_beam.transforms.window import FixedWindows
from datetime import datetime, timedelta

# Function to convert datetime to timestamp in milliseconds
def to_timestamp_milliseconds(dt):
    return int(dt.timestamp() * 1000)

# Simulate a simple streaming pipeline locally using the Direct Runner
with beam.Pipeline(runner='DirectRunner') as p:
    # Generate a PCollection of simulated streaming data with timestamps and fixed windows
    simulated_data = (
        p
        | 'Generate Data' >> beam.Create(['word1', 'word2', 'word3'])
        | 'Add Timestamps' >> beam.Map(lambda word: beam.window.TimestampedValue(word, to_timestamp_milliseconds(datetime.utcnow())))
        | 'Apply Fixed Windows' >> beam.WindowInto(FixedWindows(size=1))
    )

    # Apply transformations for WordCount
    word_counts = (
        simulated_data
        | 'ExtractWords' >> beam.FlatMap(lambda line: line.split())
        | 'PairWithOne' >> beam.Map(lambda word: (word, 1))
        | 'GroupAndSum' >> beam.CombinePerKey(sum)
    )

    # Print the word counts (for demonstration purposes)
    word_counts | 'PrintResults' >> beam.Map(print)
    result = p.run()
    result.wait_until_finish()