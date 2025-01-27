import 'dart:io';

import 'package:flutter/material.dart';

class ResourceImage extends StatelessWidget {
    final Uri uri;
    final BoxFit? fit;
    final double? width;
    final double? height;
    final AlignmentGeometry alignment;
    
    const ResourceImage({
        super.key,
        required this.uri,
        this.fit,
        this.width,
        this.height,
        this.alignment = Alignment.center,
    });

    @override
    Widget build(BuildContext context) {
        if(this.uri.toString().isEmpty)
            return const SizedBox.shrink();

        return Image(
            image: ResourceImage.provider(uri: this.uri),
            fit: this.fit,
            width: this.width,
            height: this.height,
            alignment: this.alignment,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        );
    }

    static ImageProvider<Object> provider({required Uri uri}) {
        ImageProvider<Object> image;
        if(uri.scheme == "http" || uri.scheme == "https")
            image = NetworkImage(uri.toString());
        else
            image = FileImage(File.fromUri(uri));

        image.resolve(ImageConfiguration.empty).addListener(
            ImageStreamListener(
                (_, __) {},
                onError: (_, __) => imageCache.evict(image)
            )
        );

        return image;
    }
}


