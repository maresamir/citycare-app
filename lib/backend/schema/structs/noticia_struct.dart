// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct Noticia
class NoticiaStruct extends BaseStruct {
  NoticiaStruct({
    /// Noticia.title
    String? title,

    /// Noticia.pubDate
    String? pubDate,

    /// Noticia.link
    String? link,

    /// Noticia.author
    String? author,

    /// Noticia.description
    String? description,

    /// Noticia.content
    String? content,
  })  : _title = title,
        _pubDate = pubDate,
        _link = link,
        _author = author,
        _description = description,
        _content = content;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "pubDate" field.
  String? _pubDate;
  String get pubDate => _pubDate ?? '';
  set pubDate(String? val) => _pubDate = val;

  bool hasPubDate() => _pubDate != null;

  // "link" field.
  String? _link;
  String get link => _link ?? '';
  set link(String? val) => _link = val;

  bool hasLink() => _link != null;

  // "author" field.
  String? _author;
  String get author => _author ?? '';
  set author(String? val) => _author = val;

  bool hasAuthor() => _author != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  static NoticiaStruct fromMap(Map<String, dynamic> data) => NoticiaStruct(
        title: data['title'] as String?,
        pubDate: data['pubDate'] as String?,
        link: data['link'] as String?,
        author: data['author'] as String?,
        description: data['description'] as String?,
        content: data['content'] as String?,
      );

  static NoticiaStruct? maybeFromMap(dynamic data) =>
      data is Map ? NoticiaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'pubDate': _pubDate,
        'link': _link,
        'author': _author,
        'description': _description,
        'content': _content,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'pubDate': serializeParam(
          _pubDate,
          ParamType.String,
        ),
        'link': serializeParam(
          _link,
          ParamType.String,
        ),
        'author': serializeParam(
          _author,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
      }.withoutNulls;

  static NoticiaStruct fromSerializableMap(Map<String, dynamic> data) =>
      NoticiaStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        pubDate: deserializeParam(
          data['pubDate'],
          ParamType.String,
          false,
        ),
        link: deserializeParam(
          data['link'],
          ParamType.String,
          false,
        ),
        author: deserializeParam(
          data['author'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'NoticiaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NoticiaStruct &&
        title == other.title &&
        pubDate == other.pubDate &&
        link == other.link &&
        author == other.author &&
        description == other.description &&
        content == other.content;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([title, pubDate, link, author, description, content]);
}

NoticiaStruct createNoticiaStruct({
  String? title,
  String? pubDate,
  String? link,
  String? author,
  String? description,
  String? content,
}) =>
    NoticiaStruct(
      title: title,
      pubDate: pubDate,
      link: link,
      author: author,
      description: description,
      content: content,
    );
