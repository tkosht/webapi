import pandas
from typing import Tuple


class TimeSeriesDataset(object):
    def __init__(self, data_file="data/data.tsv", freq="D"):
        self.data_df = None
        self.data_file = data_file
        self._load()._aggregate()

    def _load(self):
        data_df = pandas.read_csv(
            self.data_file, sep="\t", header=0, index_col="ds", parse_dates=True
        )
        assert "ds" in data_df.columns
        assert "y" in data_df.columns
        self.data_df = data_df
        return self

    def from_df(self, df: pandas.DataFrame):
        self.data_df = df
        return self

    def _aggregate(self):
        self.data_df = self.data_df.resample(
            self.freq, label="left", closed="left"
        ).sum()
        return self

    def split(self, predict_date: str) -> Tuple[pandas.DataFrame, pandas.DataFrame]:
        train_df = self.data_df[:predict_date].iloc[:-1]
        test_df = self.data_df[predict_date:]
        train_df.reset_index(inplace=True)
        test_df.reset_index(inplace=True)
        return train_df, test_df
