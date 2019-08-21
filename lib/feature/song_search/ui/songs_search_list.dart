import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lyrics/feature/song_search/bloc/songs_search_bloc.dart';
import 'package:flutter_bloc_lyrics/feature/song_search/bloc/songs_search_state.dart';
import 'package:flutter_bloc_lyrics/model/song_result.dart';
import 'package:url_launcher/url_launcher.dart';

class SongsSearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongsSearchBloc, SongsSearchState>(
      bloc: BlocProvider.of<SongsSearchBloc>(context),
      builder: (BuildContext context, SongsSearchState state) {
        if (state is SearchStateEmpty) {
          return Text('Enter song title');
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if(state is SearchStateSuccess){
          return state.props.isEmpty
              ? Text("No items")
              : Expanded(child: _SongsSearchResults(songsList: state.songs,),);
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class _SongsSearchResults extends StatelessWidget {
  final List<SongSearchResult> songsList;


  const _SongsSearchResults({Key key, @required this.songsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songsList.length,
        itemBuilder: (BuildContext context, int index){
          return _SongSearchResultItem(song: songsList[index].songResultItem,);
        });
  }

}

class _SongSearchResultItem extends StatelessWidget {
  final SongResultItem song;

  const _SongSearchResultItem({Key key, this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child:
    ListTile(
      leading:Image.network(song.thumbnailURL,) ,
      title: Text(song.title),
      onTap: () async {
        if(await canLaunch(song.lyricsURL)){
          await launch(song.lyricsURL);
        }
      },
    ));

  }




}